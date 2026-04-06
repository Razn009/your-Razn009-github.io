export type Role = "admin" | "agent" | "accounting";

export type RefundType =
  | "full"
  | "partial"
  | "seat"
  | "luggage"
  | "ancillary"
  | "tax"
  | "penalty";

export type CancelReason =
  | "airline_cancel"
  | "security"
  | "customer_cancel"
  | "medical"
  | "schedule_change"
  | "other";

export type RequestStatus =
  | "pending"
  | "in_progress"
  | "submitted_bsp"
  | "approved"
  | "rejected"
  | "error";

export type Currency = "USD" | "EUR" | "ILS";

export interface Agency {
  id: string;
  name: string;
  slug: string;
  email: string | null;
  plan: string;
  created_at: string;
}

export interface User {
  id: string;
  agency_id: string;
  full_name: string;
  role: Role;
  is_active: boolean;
  created_at: string;
}

export interface RefundRequest {
  id: string;
  agency_id: string;
  agent_id: string;
  doket_number: string;
  customer_name: string;
  airline: string;
  refund_type: RefundType;
  cancel_reason: CancelReason;
  ticket_numbers: string[];
  amount_expected: number | null;
  currency: Currency;
  notes: string | null;
  status: RequestStatus;
  status_notes: string | null;
  bsp_refund_id: string | null;
  amount_approved: number | null;
  created_at: string;
  updated_at: string;
}
