import type { Metadata } from "next";
import localFont from "next/font/local";
// When deploying with internet access, switch to:
// import { Heebo } from "next/font/google";
// const heebo = Heebo({ subsets: ["hebrew", "latin"], variable: "--font-heebo" });
import "./globals.css";

const heebo = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-heebo",
  display: "swap",
});

export const metadata: Metadata = {
  title: "Ganim Travel",
  description: "Ganim Travel - Refund Management System",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="he" dir="rtl">
      <body className={`${heebo.className} antialiased`}>
        {children}
      </body>
    </html>
  );
}
