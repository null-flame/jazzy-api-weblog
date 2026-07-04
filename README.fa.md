# پروژه وبلاگ با Nim و Jazzy

این پروژه یک API ساده برای مدیریت وبلاگ است که با Nim، Jazzy و SQLite ساخته شده است.

## امکانات

- ثبت‌نام کاربر
- ورود با ایمیل و رمز عبور
- ساخت پست
- مشاهده پست
- لایک کردن پست
- حذف پست
- لیست‌کردن پست‌ها با pagination
- ذخیره‌سازی داده‌ها در SQLite

## ساختار پروژه

```text
.
├── app.nim
├── config.nim
├── handlers/
│   ├── actions.nim
│   ├── auth.nim
│   └── posts.nim
├── models/
│   ├── interactions.nim
│   ├── post.nim
│   └── user.nim
├── views/
├── README.md
├── README.fa.md
└── LICENSE
```

## پیش‌نیازها

- کامپایلر Nim
- Nimble
- SQLite

## نصب

1. Nim و Nimble را نصب کنید.
2. وابستگی‌های مورد نیاز را نصب کنید:

```bash
nimble install jazzy
nimble install norm
```

3. وارد پوشه پروژه شوید:

```bash
cd jazzy_weblog_sqlite
```

## اجرای پروژه

برای اجرای برنامه از دستور زیر استفاده کنید:

```bash
nim c -r app.nim
```

سرور روی پورت 8080 اجرا می‌شود.

## مسیرهای API

### مسیرهای عمومی

- POST /api/reg — ثبت‌نام کاربر
- POST /api/loginEmail — ورود کاربر
- POST /api/view — مشاهده یک پست
- GET /api/get_post — دریافت لیست پست‌ها با pagination

### مسیرهای محافظت‌شده

- POST /api/create_post — ساخت پست جدید
- POST /api/like — لایک کردن پست
- DELETE /api/delete — حذف پست

## دیتابیس

این پروژه از SQLite استفاده می‌کند و دیتابیس در فایل `test.db` ذخیره می‌شود.

## مجوز

این پروژه تحت مجوز MIT منتشر شده است. برای جزئیات بیشتر به فایل [LICENSE](LICENSE) مراجعه کنید.
