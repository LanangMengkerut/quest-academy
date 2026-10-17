-- =====================================================================
-- Sprite avatars: default avatar baru adalah 'wizard' (sprite Sage),
-- menggantikan emoji 🧙. Nilai lama (emoji) tetap valid dan di-render
-- sebagai teks oleh komponen Avatar (fallback).
-- Idempotent: aman dijalankan ulang.
-- =====================================================================

alter table public.profiles alter column avatar set default 'wizard';
