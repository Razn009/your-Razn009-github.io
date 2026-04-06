import type { RefundType, CancelReason, RequestStatus, Currency } from "./types";

export const REFUND_TYPE_LABELS: Record<RefundType, string> = {
  full: "החזר מלא",
  partial: "החזר חלקי",
  seat: "מושב",
  luggage: "כבודה",
  ancillary: "שירותים נלווים",
  tax: "מיסים",
  penalty: "קנס",
};

export const CANCEL_REASON_LABELS: Record<CancelReason, string> = {
  airline_cancel: "ביטול חברת תעופה",
  security: "ביטחון",
  customer_cancel: "ביטול לקוח",
  medical: "רפואי",
  schedule_change: "שינוי לוח זמנים",
  other: "אחר",
};

export const STATUS_LABELS: Record<RequestStatus, string> = {
  pending: "ממתין",
  in_progress: "בטיפול",
  submitted_bsp: "הוגש ל-BSP",
  approved: "אושר",
  rejected: "נדחה",
  error: "שגיאה",
};

export const CURRENCY_LABELS: Record<Currency, string> = {
  USD: "דולר",
  EUR: "אירו",
  ILS: "שקל",
};
