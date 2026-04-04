CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE agencies (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name        TEXT NOT NULL,
  slug        TEXT UNIQUE NOT NULL,
  email       TEXT,
  plan        TEXT DEFAULT 'trial',
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE users (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  agency_id   UUID NOT NULL REFERENCES agencies(id),
  full_name   TEXT NOT NULL,
  role        TEXT NOT NULL CHECK (role IN ('admin', 'agent', 'accounting')),
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE refund_requests (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agency_id       UUID NOT NULL REFERENCES agencies(id),
  agent_id        UUID NOT NULL REFERENCES users(id),
  doket_number    TEXT NOT NULL,
  customer_name   TEXT NOT NULL,
  airline         TEXT NOT NULL,
  refund_type     TEXT NOT NULL CHECK (refund_type IN ('full','partial','seat','luggage','ancillary','tax','penalty')),
  cancel_reason   TEXT NOT NULL CHECK (cancel_reason IN ('airline_cancel','security','customer_cancel','medical','schedule_change','other')),
  ticket_numbers  TEXT[] NOT NULL,
  amount_expected NUMERIC(10,2),
  currency        TEXT DEFAULT 'USD' CHECK (currency IN ('USD','EUR','ILS')),
  notes           TEXT,
  status          TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','in_progress','submitted_bsp','approved','rejected','error')),
  status_notes    TEXT,
  bsp_refund_id   TEXT,
  amount_approved NUMERIC(10,2),
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER refund_requests_updated_at
  BEFORE UPDATE ON refund_requests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE INDEX idx_refund_requests_agency  ON refund_requests(agency_id);
CREATE INDEX idx_refund_requests_agent   ON refund_requests(agent_id);
CREATE INDEX idx_refund_requests_status  ON refund_requests(status);
CREATE INDEX idx_refund_requests_created ON refund_requests(created_at DESC);
CREATE INDEX idx_users_agency            ON users(agency_id);

ALTER TABLE agencies        ENABLE ROW LEVEL SECURITY;
ALTER TABLE users           ENABLE ROW LEVEL SECURITY;
ALTER TABLE refund_requests ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION my_agency_id() RETURNS UUID AS $$
  SELECT agency_id FROM users WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE OR REPLACE FUNCTION my_role() RETURNS TEXT AS $$
  SELECT role FROM users WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE POLICY "agency_select" ON agencies
  FOR SELECT USING (id = my_agency_id());

CREATE POLICY "users_select" ON users
  FOR SELECT USING (agency_id = my_agency_id());

CREATE POLICY "requests_select" ON refund_requests
  FOR SELECT USING (
    agency_id = my_agency_id() AND (
      my_role() IN ('admin','accounting') OR agent_id = auth.uid()
    )
  );

CREATE POLICY "requests_insert" ON refund_requests
  FOR INSERT WITH CHECK (
    agency_id = my_agency_id() AND agent_id = auth.uid()
  );

CREATE POLICY "requests_update" ON refund_requests
  FOR UPDATE USING (
    agency_id = my_agency_id() AND my_role() = 'admin'
  );
