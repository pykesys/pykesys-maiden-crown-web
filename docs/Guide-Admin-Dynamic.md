# Administrator Guide — Dynamic Platform

**Maiden Crown Press Django Ecommerce Platform**
**Location:** `./dynamic/`
**Admin URL:** https://maidencrownpress.com/admin (or http://localhost:8000/admin in development)

---

## Overview

This guide covers how to administer the Django-based ecommerce platform for Maiden Crown Press, including managing products, processing orders, managing users, and delivering digital content.

**Audience:** Site administrators, content managers, customer service
**Skill Level:** Basic familiarity with web interfaces (no coding required for most tasks)

---

## Table of Contents

1. [Accessing the Admin Panel](#accessing-the-admin-panel)
2. [Dashboard Overview](#dashboard-overview)
3. [Managing Users](#managing-users)
4. [Managing Products](#managing-products)
5. [Managing Orders](#managing-orders)
6. [Managing Content (Worlds, Chronicles)](#managing-content)
7. [Digital Product Delivery](#digital-product-delivery)
8. [Email Management](#email-management)
9. [Reports & Analytics](#reports--analytics)
10. [Troubleshooting](#troubleshooting)
11. [Security Best Practices](#security-best-practices)

---

## Accessing the Admin Panel

### Login

**Development URL:** http://localhost:8000/admin
**Production URL:** https://maidencrownpress.com/admin

**Credentials:**
- **Username:** Your admin email address
- **Password:** Set during `python manage.py createsuperuser`

**⚠️ Security:**
- Never share admin credentials
- Use a strong password (12+ characters, mixed case, numbers, symbols)
- Enable two-factor authentication (when implemented)
- Log out when finished

---

### First Login

After logging in, you'll see the Django admin dashboard with sections for:

- **Users** — User accounts and profiles
- **Products** — Product catalog, variants, categories
- **Orders** — Shopping carts, orders, transactions
- **Content API** — Worlds, chronicles, characters
- **Digital Delivery** — Digital products and downloads

---

## Dashboard Overview

### Main Sections

```
┌─────────────────────────────────────┐
│  MAIDEN CROWN PRESS ADMIN           │
├─────────────────────────────────────┤
│                                     │
│  USERS                              │
│    ├── Users                        │
│    └── User Profiles                │
│                                     │
│  PRODUCTS (when implemented)        │
│    ├── Products                     │
│    ├── Product Variants             │
│    ├── Categories                   │
│    └── Book Metadata                │
│                                     │
│  ORDERS (when implemented)          │
│    ├── Orders                       │
│    ├── Cart Items                   │
│    └── Order Items                  │
│                                     │
│  CONTENT API (when implemented)     │
│    ├── Worlds                       │
│    ├── Chronicles                   │
│    └── Characters                   │
│                                     │
│  DIGITAL DELIVERY (when implemented)│
│    ├── Digital Products             │
│    └── Downloads                    │
│                                     │
└─────────────────────────────────────┘
```

---

## Managing Users

### Viewing All Users

1. Click **Users** in the admin panel
2. You'll see a list of all registered users

**List View Columns:**
- Email
- Username
- First Name / Last Name
- Staff Status
- Newsletter Subscription
- Date Joined

**Actions:**
- **Search:** Use the search bar (top right) to find users by email, name, or username
- **Filter:** Use the right sidebar to filter by staff status, active status, newsletter subscription
- **Sort:** Click column headers to sort

---

### Viewing/Editing a User

1. Click on a user's email in the list
2. You'll see the user detail page with tabs:

**Personal Info:**
- Username
- Email address
- First name / Last name
- Newsletter subscription preference

**Permissions:**
- Active (user can log in)
- Staff status (can access admin)
- Superuser status (full admin access)

**Important Dates:**
- Date joined
- Last login

**User Profile (Inline):**
- Phone number
- Birth date
- Shipping address
- Billing address

**Changing a Password:**
1. Click "this form" link in the password field
2. Enter new password twice
3. Click "Change Password"

---

### Creating a New Admin User

**Method 1: Via Admin Panel**
1. Go to **Users** → **Add User**
2. Enter email and password
3. Click "Save and continue editing"
4. Set "Staff status" to checked
5. Optionally set "Superuser status" for full access
6. Fill in additional details
7. Click "Save"

**Method 2: Via Command Line**
```bash
python manage.py createsuperuser
```

---

### Deleting a User

**⚠️ Warning:** This permanently deletes the user and all related data (orders, profiles, etc.)

1. Go to **Users**
2. Check the box next to user(s) to delete
3. Select "Delete selected users" from the action dropdown
4. Click "Go"
5. Confirm deletion

**Alternative:** Deactivate instead of deleting:
1. Edit the user
2. Uncheck "Active" status
3. Save

---

## Managing Products

### Product Hierarchy

```
Category (e.g., "Science Fiction")
  └── Product (e.g., "The Weight of Thirty Worlds - Book 1")
        ├── Product Variant (Hardcover - $29.99)
        ├── Product Variant (Paperback - $16.99)
        ├── Product Variant (eBook - $9.99)
        ├── Product Variant (Audiobook - $19.99)
        └── Book Metadata (Author, Series, ISBN, etc.)
```

---

### Creating a Category

1. Go to **Products** → **Categories**
2. Click **Add Category** (top right)
3. Fill in:
   - **Name:** e.g., "Science Fiction"
   - **Slug:** Auto-generated, or customize (e.g., "sci-fi")
   - **Description:** Optional
   - **Parent:** Select a parent category for nested categories
4. Click **Save**

---

### Creating a Product

#### Step 1: Create the Base Product

1. Go to **Products** → **Products**
2. Click **Add Product**
3. Fill in required fields:

**Basic Info:**
- **Name:** Full product name (e.g., "The Weight of Thirty Worlds - Book 1")
- **Slug:** Auto-generated from name (e.g., "weight-of-thirty-worlds-1")
- **Product Type:** Book, Merchandise, or Bundle
- **SKU:** Unique identifier (e.g., "WOTW-1")

**Description:**
- **Short Description:** 1-2 sentences for catalog listings
- **Full Description:** Complete product description (supports HTML)

**Pricing:**
- **Base Price:** Starting price (variants can override)

**Status:**
- **Status:** Draft, Active, Pre-order, Coming Soon, Out of Stock, Discontinued
- **Featured:** Check to show on homepage

**Release Info:**
- **Release Date:** Official release date (for pre-orders)
- **Pre-order Start Date:** When pre-orders open

**Media:**
- **Image:** Main product image (upload or select existing)
- **Thumbnail:** Auto-generated or custom thumbnail

**Organization:**
- **Category:** Select from dropdown

4. Click **Save and continue editing**

---

#### Step 2: Add Product Variants

**In the same product edit screen, scroll to "Product Variants" section:**

1. Click **Add another Product Variant**
2. Fill in:
   - **Format Type:** Hardcover, Paperback, eBook, Audiobook, Signed, Limited
   - **SKU:** Unique (e.g., "WOTW-1-HC" for hardcover)
   - **Price:** Variant price
   - **Compare at Price:** Original price (for showing discounts)
   - **Inventory Quantity:** Stock count (leave blank for digital)
   - **Is Digital:** Check for eBooks/audiobooks
   - **Digital File:** Upload file for digital products (stored in S3)
   - **ISBN:** ISBN-13 for books
   - **Pages:** Page count
   - **Weight:** Shipping weight in kg
   - **Is Active:** Checked to make variant purchasable

3. Repeat for each format
4. Click **Save**

---

#### Step 3: Add Book Metadata (Books Only)

**In the same product edit screen, scroll to "Book Metadata" section:**

1. Fill in:
   - **Author:** e.g., "Maiden Crown Press"
   - **Series:** e.g., "The Weight of Thirty Worlds"
   - **Series Number:** e.g., 1
   - **Publisher:** Default: "Maiden Crown Press"
   - **Genre:** e.g., "Science Fiction, Space Opera"
   - **Target Audience:** e.g., "Adult"
   - **Excerpt:** Paste sample chapter or excerpt

2. Click **Save**

---

### Product Checklist

Before publishing a product:

- [ ] Name and description filled out
- [ ] At least one variant created
- [ ] Pricing set on all variants
- [ ] Inventory quantity set (for physical products)
- [ ] Product image uploaded
- [ ] Book metadata complete (for books)
- [ ] Category assigned
- [ ] SKU is unique
- [ ] Status set to "Active" or "Pre-order"

---

### Managing Inventory

**Viewing Inventory:**
1. Go to **Products** → **Product Variants**
2. Filter by format type or product
3. Check "Inventory Quantity" column

**Updating Inventory:**
1. Click on a variant
2. Change "Inventory Quantity"
3. Click **Save**

**Low Stock Alerts:**
- Set up email alerts (when implemented)
- Manually check inventory weekly

**Out of Stock:**
- Set variant "Is Active" to unchecked
- Or change product status to "Out of Stock"

---

## Managing Orders

### Order Lifecycle

```
Cart → Checkout → Payment → Order Created → Processing → Shipped → Delivered
                      ↓
                  Failed → Cart restored
```

---

### Viewing Orders

1. Go to **Orders** → **Orders**
2. View list of all orders

**List Columns:**
- Order Number
- Customer (email)
- Total
- Status
- Payment Method
- Created Date

**Filtering:**
- By status (pending, paid, processing, shipped, delivered)
- By date range
- By customer

**Searching:**
- Order number
- Customer email
- Customer name

---

### Processing an Order

#### Step 1: Review Order Details

1. Click on an order to view details:
   - Customer information
   - Shipping address
   - Billing address
   - Order items (products, quantities, prices)
   - Payment information (Stripe payment intent)
   - Order total breakdown (subtotal, tax, shipping)

---

#### Step 2: Update Order Status

**Status Options:**
- **Pending:** Order created, awaiting payment
- **Paid:** Payment confirmed
- **Processing:** Order is being prepared
- **Shipped:** Order dispatched
- **Delivered:** Order received by customer
- **Cancelled:** Order cancelled
- **Refunded:** Payment refunded

**To update:**
1. Change "Status" dropdown
2. Add notes if needed
3. Click **Save**

**⚠️ Automatic actions on status change:**
- **Paid → Processing:** Email sent to customer (order confirmation)
- **Processing → Shipped:** Email sent with tracking number
- **Paid → Refunded:** Stripe refund initiated

---

#### Step 3: Add Tracking Information

1. Edit the order
2. Enter "Tracking Number" (e.g., from UPS, FedEx, USPS)
3. Change status to "Shipped"
4. Click **Save**
5. Customer receives email with tracking link

---

### Handling Refunds

**Full Refund:**
1. Open the order
2. Change status to "Refunded"
3. Add reason in notes
4. Click **Save**
5. Stripe processes refund automatically

**Partial Refund:**
1. Log into Stripe dashboard
2. Find payment intent
3. Issue partial refund
4. Update order notes in Django admin

---

### Cancelled Orders

**Customer Requested Cancellation:**
1. Find order in admin
2. Check payment status:
   - **Not paid:** Change status to "Cancelled"
   - **Paid:** Issue refund, then change to "Cancelled"
3. Send confirmation email to customer
4. Click **Save**

---

### Order Reports

**Daily Orders:**
1. Go to **Orders** → **Orders**
2. Filter by "Created date" → Today
3. Export as CSV (action dropdown)

**Monthly Sales:**
1. Filter by date range (e.g., last 30 days)
2. Check total in summary (if implemented)
3. Export for accounting

---

## Managing Content

### Content Workflow

```
Draft → Review → Approved → Published → Market (Public API)
```

This supports the Auger → Forge → Foundry → Market pipeline.

---

### Creating a World

1. Go to **Content API** → **Worlds**
2. Click **Add World**
3. Fill in:
   - **Name:** e.g., "Dispensation Prime"
   - **Slug:** Auto-generated or custom
   - **Description:** Rich text description
   - **Order:** Numerical order for display
   - **Is Published:** Check to make public
   - **Metadata:** JSON field for custom data (advanced)
4. Click **Save**

---

### Creating a Chronicle

1. Go to **Content API** → **Chronicles**
2. Click **Add Chronicle**
3. Fill in:
   - **Title:** e.g., "The First Dispensation"
   - **Slug:** Auto-generated
   - **Content:** Full chronicle text (rich text editor)
   - **Excerpt:** Short summary
   - **World:** Select associated world (optional)
   - **Order:** Display order
   - **Is Published:** Public visibility
   - **Published Date:** When to show (can schedule)
   - **Author:** Content creator
   - **Metadata:** Custom JSON data
4. Click **Save**

---

### Creating a Character

1. Go to **Content API** → **Characters**
2. Click **Add Character**
3. Fill in:
   - **Name:** Character name
   - **Slug:** Auto-generated
   - **Biography:** Character backstory/description
   - **World:** Associated world
   - **Role:** Protagonist, Antagonist, Supporting, etc.
   - **Image:** Character portrait (upload)
   - **Is Published:** Public visibility
   - **Metadata:** Custom data
4. Click **Save**

---

### Publishing Workflow (Future Feature)

**For Foundry approval process:**

1. Content creator creates draft (is_published = False)
2. Submits for review
3. Approver reviews in admin
4. Approver marks "Is Published" = True
5. Content appears in public API
6. Front-end fetches from API

---

## Digital Product Delivery

### Setting Up Digital Delivery

#### Step 1: Upload Digital File

1. Create/edit a Product Variant
2. Check "Is Digital"
3. Upload file in "Digital File" field
4. File is stored in AWS S3
5. Save variant

---

#### Step 2: Configure Digital Product Settings

1. Go to **Digital Delivery** → **Digital Products**
2. Find or create digital product linked to variant
3. Set:
   - **Download Limit:** How many times customer can download (e.g., 5)
   - **Expiration Days:** How long download link is valid (e.g., 30 days)
4. Click **Save**

---

### Automatic Delivery Process

**When an order is paid:**

1. System detects digital products in order
2. Celery task generates download links
3. Email sent to customer with download links
4. Download records created in database
5. Customer can access downloads from:
   - Email link
   - Account dashboard → My Downloads

---

### Manual Delivery (Troubleshooting)

**If customer didn't receive download link:**

1. Go to **Digital Delivery** → **Downloads**
2. Find customer's downloads by email/order
3. Click "Resend Download Link" button
4. Or copy download URL and send manually

**Generating New Download Link:**
1. Find the download record
2. Click "Regenerate Token"
3. New secure link is created
4. Send to customer

---

### Tracking Downloads

**View Download Activity:**
1. Go to **Digital Delivery** → **Downloads**
2. See all download records with:
   - Customer email
   - Product name
   - Download count
   - Expiration date
   - Last downloaded date
   - IP address

**Investigating Issues:**
- Check download count (hitting limit?)
- Check expiration date (expired?)
- Check download attempts from unusual IPs (potential abuse)

---

## Email Management

### Email Types

1. **Order Confirmation** (order placed)
2. **Payment Confirmation** (payment successful)
3. **Shipping Notification** (order shipped with tracking)
4. **Digital Delivery** (download links)
5. **Password Reset** (user requested)
6. **Account Activation** (new user registration)

---

### Email Templates

**Location:** `dynamic/templates/email/`

**Customizing:**
1. Edit template files (HTML + plain text)
2. Use Django template variables: `{{ order.order_number }}`
3. Test locally: `python manage.py sendtestemail`
4. Deploy changes

**Variables Available:**
- `{{ user.first_name }}`
- `{{ order.order_number }}`
- `{{ order.total }}`
- `{{ tracking_number }}`
- `{{ download_links }}`

---

### Testing Emails

**In Development:**
Emails are sent to console (terminal output).

**Check logs:**
```bash
# Run server and watch console
python manage.py runserver
# Trigger email action
# See email content in terminal
```

**In Production:**
Use SendGrid dashboard to monitor:
- Delivery rate
- Open rate
- Bounce rate
- Spam reports

---

### Resending Emails

**Order Confirmation:**
1. Go to order detail
2. Click "Resend Confirmation Email" button

**Digital Delivery:**
1. Go to **Digital Delivery** → **Downloads**
2. Find download record
3. Click "Resend Download Link"

---

## Reports & Analytics

### Built-in Django Admin Reports

**User Growth:**
1. Go to **Users** → **Users**
2. Filter by "Date joined" → This month
3. Count total users

**Sales Summary:**
1. Go to **Orders** → **Orders**
2. Filter by date range
3. Export as CSV
4. Open in Excel/Google Sheets
5. Calculate totals

---

### Export Data

**Exporting to CSV:**
1. Go to any list view (Users, Orders, Products)
2. Select items (or select all)
3. Choose "Export selected as CSV" from actions dropdown
4. Click "Go"
5. Download CSV file

**Uses:**
- Accounting reports
- Customer email lists
- Product inventory reports
- Sales analysis

---

### External Analytics (Future)

**Google Analytics:**
- Track page views
- User behavior
- Conversion funnel

**Stripe Dashboard:**
- Payment volume
- Revenue trends
- Failed payments
- Refund rate

---

## Troubleshooting

### Common Issues

#### Issue: Can't Log In to Admin

**Possible Causes:**
1. Wrong username/password
2. Account not active
3. Account not staff

**Solutions:**
1. Reset password via command line:
   ```bash
   python manage.py changepassword your-email@example.com
   ```

2. Check account status:
   ```bash
   python manage.py shell
   >>> from apps.users.models import User
   >>> user = User.objects.get(email='your-email@example.com')
   >>> user.is_active
   True  # Should be True
   >>> user.is_staff
   True  # Should be True
   >>> user.is_staff = True
   >>> user.save()
   ```

---

#### Issue: Product Not Showing on Site

**Checklist:**
- [ ] Product status is "Active"
- [ ] At least one variant is active
- [ ] Product has an image
- [ ] Product is in a category
- [ ] Inventory > 0 (for physical products)

**Debug:**
1. Check API endpoint: `/api/v1/products/`
2. Look for your product in JSON response
3. If missing, check filters

---

#### Issue: Customer Didn't Receive Order Confirmation

**Check:**
1. Email delivery logs (SendGrid dashboard)
2. Customer's spam folder
3. Email address correct in order

**Solution:**
1. Resend order confirmation from admin
2. Or send manual email with order details

---

#### Issue: Digital Download Link Expired

**Solution:**
1. Go to **Digital Delivery** → **Downloads**
2. Find customer's download
3. Click "Regenerate Token"
4. New link created with fresh expiration
5. Send new link to customer

---

#### Issue: Stripe Payment Failed

**Check:**
1. Stripe dashboard for error details
2. Common errors:
   - Card declined
   - Insufficient funds
   - CVC check failed
   - Expired card

**Solution:**
1. Contact customer to update payment method
2. Create new checkout session
3. Or process payment manually via Stripe dashboard

---

## Security Best Practices

### Admin Access

1. **Use Strong Passwords**
   - 12+ characters
   - Mix of uppercase, lowercase, numbers, symbols
   - Never reuse passwords

2. **Enable Two-Factor Authentication** (when available)
   - Use authenticator app (Google Authenticator, Authy)
   - Keep backup codes safe

3. **Limit Admin Users**
   - Only create admin accounts for staff who need them
   - Use "staff" status instead of "superuser" when possible

4. **Log Out After Use**
   - Never leave admin panel open on shared computers
   - Clear browser cache/cookies when using public computers

---

### Password Management

**For Yourself:**
- Use a password manager (1Password, LastPass, Bitwarden)
- Never share admin credentials
- Change password every 90 days

**For Customers:**
- Never ask for customer passwords
- Direct them to use "Forgot Password" link
- Can reset via admin if necessary (generates new password)

---

### Data Privacy

**GDPR Compliance:**
- Only access customer data when necessary
- Don't share customer information externally
- Honor data deletion requests
- Keep data secure

**Customer Data Requests:**
1. **Data Export:** Use CSV export feature
2. **Data Deletion:** Delete user from admin (after checking legal requirements)

---

### Handling Sensitive Information

**Payment Data:**
- Never store full credit card numbers
- Stripe handles PCI compliance
- Only store last 4 digits (via Stripe)

**Personal Data:**
- Encrypt in database (Django handles this)
- Use HTTPS for all admin access
- Don't send sensitive data via email

---

## Quick Reference

### Daily Tasks
- [ ] Check new orders
- [ ] Process pending orders
- [ ] Respond to customer inquiries
- [ ] Check inventory levels

### Weekly Tasks
- [ ] Review sales reports
- [ ] Check low stock products
- [ ] Review user registrations
- [ ] Monitor failed payments

### Monthly Tasks
- [ ] Export sales data for accounting
- [ ] Review and update product descriptions
- [ ] Check for expired download links
- [ ] Security audit (check admin users)

---

## Command Line Shortcuts

**For advanced users:**

```bash
# Create superuser
python manage.py createsuperuser

# Change password
python manage.py changepassword email@example.com

# Clear expired sessions
python manage.py clearsessions

# Collect static files
python manage.py collectstatic

# Database backup
python manage.py dumpdata > backup.json

# Restore from backup
python manage.py loaddata backup.json

# Run Django shell
python manage.py shell

# Check for issues
python manage.py check
```

---

## Getting Help

### Internal Resources

- **Developer Documentation:** `docs/project-dynamic.md`
- **Setup Guide:** `dynamic/GETTING_STARTED.md`
- **Django Docs:** https://docs.djangoproject.com/

### External Support

- **Django Admin Docs:** https://docs.djangoproject.com/en/5.0/ref/contrib/admin/
- **Stripe Support:** https://support.stripe.com/
- **SendGrid Support:** https://sendgrid.com/support/

### Escalation

**For technical issues beyond admin panel:**
- Contact your development team
- Check GitHub Issues
- Email: tech@maidencrownpress.com (if configured)

---

## Appendix: Admin Permissions

### User Roles

**Superuser:**
- Full access to everything
- Can create/delete other admins
- Can change site settings
- Use sparingly

**Staff:**
- Can access admin panel
- Limited to assigned permissions
- Cannot change settings
- Good for content managers

**Regular User:**
- No admin access
- Can only access their own account
- Customer-facing

---

### Setting Permissions

1. Edit a user
2. Uncheck "Superuser status"
3. Check "Staff status"
4. Scroll to "User permissions" section
5. Select specific permissions:
   - `products | product | Can add product`
   - `products | product | Can change product`
   - `orders | order | Can view order`
   - etc.
6. Or assign to a "Group" with predefined permissions

---

**You are now ready to administer the Maiden Crown Press ecommerce platform. The records are in your hands. Maintain them well.**

*🛡️ Secure. Efficient. Professional.*
