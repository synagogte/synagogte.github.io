# Automatic saving, without a login

1. Open [your Supabase project's SQL Editor](https://supabase.com/dashboard/project/cmujcdgexaeunpyoedfj/sql/new).
2. Paste the entire updated `knitting-setup.sql` into a new query and click **Run**. Nothing needs replacing. No Auth user or password is needed. It also updates the earlier owner-only setup if you already ran it, preserving your board.
3. Publish the updated `knitting.html` through your normal GitHub/Vercel workflow.
4. Open the page in the same browser and at the same site address where you already edited it. Your existing list uploads automatically if the online board is empty. If you already saved an online board and the browser has different unsynced changes, choose which version to keep.
5. Open the page in any other browser or device. Your saved board loads automatically.

The footer shows whether changes have saved online. Edits to notes and progress save as you type; use Save project after editing a project's main details. Photos, order, statuses, projects and yarn links save with the board. Export is only an optional backup.

Offline edits stay in that browser and retry when the connection returns. If a newer online version exists, you choose before replacing it. Choosing the online version keeps a recovery copy of your displaced browser draft under `syna-knit-list-v1-before-cloud` in localStorage. The total saved board can contain up to 20 MB including resized photos.

Anyone with the page URL can view and change the same board, including its notes and photos. This setup intentionally has no authentication. The database permissions allow reading/updating the existing board, with no public insert or delete access.

Live database saving still requires the SQL setup. Browser behavior is tested with an isolated simulated Supabase backend. This setup changes only the knitting table; travel notes are unaffected.
