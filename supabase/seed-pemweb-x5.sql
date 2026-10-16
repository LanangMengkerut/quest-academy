insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$pemweb-x5$qa$, $qa$pemweb$qa$, $qa$Dasar-dasar Javascript$qa$, $qa$<h3>JavaScript di Web</h3>
<p><strong>JavaScript</strong> adalah bahasa pemrograman untuk membuat halaman web <strong>interaktif dan dinamis</strong>. Berjalan di sisi <strong>client</strong> (browser mengeksekusi script setelah mengunduh halaman). Cara menampilkan output: <code>console.log()</code> (ke console), <code>alert()</code> (kotak dialog), dan manipulasi DOM (mengubah isi halaman).</p>
<h3>Variabel &amp; Tipe Data</h3>
<ul>
<li>Deklarasi: <code>var</code> (lama), <code>let</code> (bisa diubah), <code>const</code> (tetap).</li>
<li>Tipe data: <strong>string</strong>, <strong>number</strong>, <strong>boolean</strong>, <strong>null</strong>, <strong>undefined</strong>, <strong>object</strong>, <strong>array</strong>.</li>
<li>Waspadai <strong>koersi tipe</strong>: <code>2 + "2"</code> menghasilkan <code>"22"</code> (number diubah jadi string).</li>
</ul>
<h3>Kondisional &amp; Perulangan</h3>
<ul>
<li><strong>Percabangan:</strong> <code>if / else if / else</code> dan <code>switch</code>.</li>
<li><strong>Perulangan:</strong> <code>for</code> (jumlah pasti), <code>while</code> (selama kondisi benar), <code>do...while</code> (minimal jalan sekali).</li>
<li>Operator perbandingan: <code>==</code> (longgar, boleh konversi tipe) vs <code>===</code> (ketat, tipe harus sama).</li>
</ul>
<h3>Array &amp; Object</h3>
<ul>
<li><strong>Array</strong> (notasi literal): <code>let buah = ["apel", "mangga"];</code> — akses via indeks <code>buah[0]</code>.</li>
<li><strong>Object</strong> (notasi literal): <code>let mhs = { nama: "Budi", nim: 123 };</code> — akses via <code>mhs.nama</code> atau <code>mhs["nama"]</code>.</li>
</ul>
<h3>Fungsi</h3>
<ul>
<li><strong>Deklarasi fungsi</strong> (<code>function sapa() {...}</code>) vs <strong>ekspresi fungsi</strong> (<code>const sapa = function() {...}</code>).</li>
<li>Fungsi menerima <strong>parameter</strong> dan mengembalikan nilai lewat <strong>return</strong>.</li>
<li><strong>Hoisting:</strong> deklarasi <code>var</code> dan function declaration "diangkat" ke atas scope sehingga bisa dipanggil sebelum baris definisinya.</li>
<li><strong>Callback:</strong> fungsi yang dikirim sebagai argumen dan dipanggil di dalam fungsi lain.</li>
<li><strong>Scope:</strong> variabel hanya dikenal di dalam blok/fungsi tempat ia dideklarasikan.</li>
</ul>
<h3>DOM (Document Object Model)</h3>
<p>DOM adalah representasi <strong>pohon (tree)</strong> dari dokumen HTML berisi <strong>nodes</strong>. Metode seleksi:</p>
<ul>
<li><code>getElementById("judul")</code> → satu elemen.</li>
<li><code>getElementsByClassName()</code> / <code>getElementsByTagName()</code> → koleksi HTMLCollection.</li>
<li><code>querySelector(".menu")</code> → elemen pertama yang cocok; <code>querySelectorAll()</code> → <strong>NodeList</strong> semua yang cocok.</li>
</ul>
<h3>Modifikasi DOM</h3>
<ul>
<li>Ubah konten: <code>el.textContent</code> / <code>el.innerHTML</code>.</li>
<li>Ubah style: <code>el.style.color = "red"</code>.</li>
<li>Buat &amp; tambah elemen: <code>document.createElement()</code> + <code>parent.appendChild()</code>; hapus dengan <code>el.remove()</code>.</li>
</ul>$qa$, null, null, 5) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s1$qa$, $qa$pemweb-x5$qa$, $qa$JavaScript di Web$qa$, $qa$<p><strong>JavaScript</strong> adalah bahasa pemrograman untuk membuat halaman web <strong>interaktif dan dinamis</strong>. Berjalan di sisi <strong>client</strong> (browser mengeksekusi script setelah mengunduh halaman). Cara menampilkan output: <code>console.log()</code> (ke console), <code>alert()</code> (kotak dialog), dan manipulasi DOM (mengubah isi halaman).</p>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s2$qa$, $qa$pemweb-x5$qa$, $qa$Variabel & Tipe Data$qa$, $qa$<ul>
<li>Deklarasi: <code>var</code> (lama), <code>let</code> (bisa diubah), <code>const</code> (tetap).</li>
<li>Tipe data: <strong>string</strong>, <strong>number</strong>, <strong>boolean</strong>, <strong>null</strong>, <strong>undefined</strong>, <strong>object</strong>, <strong>array</strong>.</li>
<li>Waspadai <strong>koersi tipe</strong>: <code>2 + "2"</code> menghasilkan <code>"22"</code> (number diubah jadi string).</li>
</ul>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s3$qa$, $qa$pemweb-x5$qa$, $qa$Kondisional & Perulangan$qa$, $qa$<ul>
<li><strong>Percabangan:</strong> <code>if / else if / else</code> dan <code>switch</code>.</li>
<li><strong>Perulangan:</strong> <code>for</code> (jumlah pasti), <code>while</code> (selama kondisi benar), <code>do...while</code> (minimal jalan sekali).</li>
<li>Operator perbandingan: <code>==</code> (longgar, boleh konversi tipe) vs <code>===</code> (ketat, tipe harus sama).</li>
</ul>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s4$qa$, $qa$pemweb-x5$qa$, $qa$Array & Object$qa$, $qa$<ul>
<li><strong>Array</strong> (notasi literal): <code>let buah = ["apel", "mangga"];</code> — akses via indeks <code>buah[0]</code>.</li>
<li><strong>Object</strong> (notasi literal): <code>let mhs = { nama: "Budi", nim: 123 };</code> — akses via <code>mhs.nama</code> atau <code>mhs["nama"]</code>.</li>
</ul>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s5$qa$, $qa$pemweb-x5$qa$, $qa$Fungsi$qa$, $qa$<ul>
<li><strong>Deklarasi fungsi</strong> (<code>function sapa() {...}</code>) vs <strong>ekspresi fungsi</strong> (<code>const sapa = function() {...}</code>).</li>
<li>Fungsi menerima <strong>parameter</strong> dan mengembalikan nilai lewat <strong>return</strong>.</li>
<li><strong>Hoisting:</strong> deklarasi <code>var</code> dan function declaration "diangkat" ke atas scope sehingga bisa dipanggil sebelum baris definisinya.</li>
<li><strong>Callback:</strong> fungsi yang dikirim sebagai argumen dan dipanggil di dalam fungsi lain.</li>
<li><strong>Scope:</strong> variabel hanya dikenal di dalam blok/fungsi tempat ia dideklarasikan.</li>
</ul>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s6$qa$, $qa$pemweb-x5$qa$, $qa$DOM (Document Object Model)$qa$, $qa$<p>DOM adalah representasi <strong>pohon (tree)</strong> dari dokumen HTML berisi <strong>nodes</strong>. Metode seleksi:</p>
<ul>
<li><code>getElementById("judul")</code> → satu elemen.</li>
<li><code>getElementsByClassName()</code> / <code>getElementsByTagName()</code> → koleksi HTMLCollection.</li>
<li><code>querySelector(".menu")</code> → elemen pertama yang cocok; <code>querySelectorAll()</code> → <strong>NodeList</strong> semua yang cocok.</li>
</ul>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$pemweb-x5-s7$qa$, $qa$pemweb-x5$qa$, $qa$Modifikasi DOM$qa$, $qa$<ul>
<li>Ubah konten: <code>el.textContent</code> / <code>el.innerHTML</code>.</li>
<li>Ubah style: <code>el.style.color = "red"</code>.</li>
<li>Buat &amp; tambah elemen: <code>document.createElement()</code> + <code>parent.appendChild()</code>; hapus dengan <code>el.remove()</code>.</li>
</ul>$qa$, 7) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-c1$qa$, $qa$pemweb-x5$qa$, $qa$checkpoint$qa$, $qa$Apa hasil dari 2 + "2" di JavaScript?$qa$, $qa$["4", "\"22\"", "Error tipe data", "NaN"]$qa$::jsonb, 1, $qa$Terjadi koersi tipe: number 2 diubah menjadi string sehingga hasilnya "22".$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-c2$qa$, $qa$pemweb-x5$qa$, $qa$checkpoint$qa$, $qa$Apa beda == dan === di JavaScript?$qa$, $qa$["Tidak ada bedanya", "== membandingkan longgar (boleh konversi tipe), === ketat (tipe harus sama)", "== hanya untuk string, === hanya untuk number", "=== sudah usang, diganti =="]$qa$::jsonb, 1, $qa$== longgar dan boleh mengonversi tipe, sedangkan === ketat: nilai dan tipe harus sama.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-c3$qa$, $qa$pemweb-x5$qa$, $qa$checkpoint$qa$, $qa$document.querySelector(".menu") mengembalikan...$qa$, $qa$["Semua elemen berclass menu sebagai NodeList", "Elemen pertama yang cocok dengan selektor", "Selalu null", "Koleksi HTMLCollection"]$qa$::jsonb, 1, $qa$querySelector mengembalikan elemen pertama yang cocok; querySelectorAll mengembalikan NodeList semua yang cocok.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-b1$qa$, $qa$pemweb-x5$qa$, $qa$battle$qa$, $qa$Apa output dari console.log(2 + "2") di JavaScript?$qa$, $qa$["4", "\"22\"", "NaN", "Error"]$qa$::jsonb, 1, $qa$Terjadi koersi tipe: number 2 diubah menjadi string lalu digabung, menghasilkan string "22".$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-b2$qa$, $qa$pemweb-x5$qa$, $qa$battle$qa$, $qa$Perbedaan == dan === di JavaScript adalah...$qa$, $qa$["Tidak ada perbedaan", "== membandingkan tanpa konversi tipe, === dengan konversi tipe", "== boleh melakukan konversi tipe, === menuntut tipe data sama", "=== hanya untuk string"]$qa$::jsonb, 2, $qa$Operator == longgar ("5" == 5 bernilai true), sedangkan === ketat ("5" === 5 bernilai false).$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-b3$qa$, $qa$pemweb-x5$qa$, $qa$battle$qa$, $qa$Method document.querySelectorAll(".menu") mengembalikan...$qa$, $qa$["Satu elemen pertama", "NodeList berisi semua elemen yang cocok", "Sebuah string", "Nilai boolean"]$qa$::jsonb, 1, $qa$querySelectorAll mengembalikan NodeList (koleksi) semua elemen yang cocok dengan selektor.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-b4$qa$, $qa$pemweb-x5$qa$, $qa$battle$qa$, $qa$Konsep hoisting pada JavaScript berarti...$qa$, $qa$["Fungsi tidak bisa dipanggil sebelum didefinisikan", "Deklarasi var dan function declaration dianggap dipindah ke atas scope-nya", "Variabel otomatis terhapus setelah dipakai", "Kode berjalan dari bawah ke atas"]$qa$::jsonb, 1, $qa$Hoisting mengangkat deklarasi ke puncak scope, sehingga function declaration bisa dipanggil sebelum baris definisinya.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$pemweb-x5-b5$qa$, $qa$pemweb-x5$qa$, $qa$battle$qa$, $qa$Untuk mengganti teks di dalam elemen yang sudah diseleksi (el), cara yang tepat adalah...$qa$, $qa$["el.textContent = \"baru\";", "el = \"baru\";", "textContent(el, \"baru\");", "el.innerTextContent();"]$qa$::jsonb, 0, $qa$Properti textContent (atau innerHTML bila berisi markup) dipakai untuk mengubah isi teks elemen.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
