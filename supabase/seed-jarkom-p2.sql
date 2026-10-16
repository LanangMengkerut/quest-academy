insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p2$qa$, $qa$jarkom$qa$, $qa$Model Referensi Jaringan$qa$, $qa$<h3>Arsitektur Berlapis</h3>
<p>Komunikasi antar komputer yang berjauhan terlalu kompleks untuk ditangani sekaligus, sehingga dipecah menjadi sub-masalah independen per layer. Keuntungannya: <strong>modularitas</strong> (ganti kabel tembaga ke fiber tanpa merusak WhatsApp), <strong>interoperabilitas</strong> (Cisco dan Mikrotik bisa tersambung), dan <strong>pemeliharaan mudah</strong>.</p>
<h3>Model OSI — 7 Layer</h3>
<p>Dirilis ISO tahun 1984. Hafalkan dari bawah dengan <strong>Please Do Not Throw Sausage Pizza Away</strong>:</p>
<table>
<tr><th>Layer</th><th>Nama</th><th>Fungsi kunci</th><th>PDU</th></tr>
<tr><td>7</td><td>Application</td><td>Antarmuka layanan jaringan (HTTP, SMTP, FTP)</td><td>Data</td></tr>
<tr><td>6</td><td>Presentation</td><td>Format data, enkripsi, kompresi</td><td>Data</td></tr>
<tr><td>5</td><td>Session</td><td>Manajemen dialog & checkpoint sinkronisasi</td><td>Data</td></tr>
<tr><td>4</td><td>Transport</td><td>Pengiriman end-to-end antar proses (port, segmentasi)</td><td>Segment</td></tr>
<tr><td>3</td><td>Network</td><td>Pengalamatan logis (IP) & routing antar jaringan</td><td>Packet</td></tr>
<tr><td>2</td><td>Data Link</td><td>Transfer node-to-node, MAC address, framing, CRC</td><td>Frame</td></tr>
<tr><td>1</td><td>Physical</td><td>Bit 0/1 menjadi sinyal listrik/cahaya/radio</td><td>Bits</td></tr>
</table>
<h3>Enkapsulasi & Dekapsulasi</h3>
<p><strong>Enkapsulasi:</strong> data turun dari layer atas ke bawah, tiap layer menambahkan <strong>header</strong> informasinya (Data Link menambah header + trailer). <strong>Dekapsulasi:</strong> di penerima data naik, tiap layer membaca lalu membuang headernya sebelum meneruskan ke atas.</p>
<h3>Model TCP/IP</h3>
<p>Dibuat Vint Cerf & Bob Kahn untuk ARPANET — protokolnya dipakai dulu sampai matang, baru ditulis jadi standar. Versi modern 5 layer: Application (gabungan 3 layer teratas OSI), Transport (TCP/UDP), Internet (IP, best-effort; dibantu ICMP & ARP), Link, Physical.</p>
<h3>OSI vs TCP/IP</h3>
<p>OSI kalah dominasi karena: <strong>terlambat</strong> (saat standarnya terbit 1984, TCP/IP sudah dipakai luas), <strong>terlalu kompleks</strong> (layer session & presentation jarang berguna tapi memberatkan), dan <strong>implementasi awal lambat</strong>.</p>
<h3>Empat Level Pengalamatan</h3>
<table>
<tr><th>Alamat</th><th>Layer</th><th>Keterangan</th></tr>
<tr><td>Physical (MAC)</td><td>2</td><td>48-bit heksadesimal, permanen di NIC</td></tr>
<tr><td>Logical (IP)</td><td>3</td><td>32-bit, berubah mengikuti jaringan</td></tr>
<tr><td>Port</td><td>4</td><td>16-bit, mengarah ke aplikasi (mis. 80, 443)</td></tr>
<tr><td>Specific</td><td>7</td><td>Nama ramah manusia: URL, alamat email</td></tr>
</table>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan02.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 2) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s1$qa$, $qa$jarkom-p2$qa$, $qa$Model Referensi Jaringan$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>
            
            <section>
                <div>
                    
                    <h3>Pertemuan 2</h3>
                </div>
                <p>Referensi Utama: Forouzan - <em>Data Communications and Networking (5th Ed)</em></p>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
            </section>

            <section>
                <h3>Outline Materi</h3>
                <div>
                    <ul>
                        <li>Konsep Arsitektur Berlapis (Layering)</li>
                        <li>Model Referensi OSI 7 Lapis</li>
                        <li>Enkapsulasi & Dekapsulasi Data</li>
                        <li>Model TCP/IP (Protokol Internet)</li>
                        <li>Perbandingan OSI vs TCP/IP</li>
                        <li>Pengalamatan (Addressing) di Jaringan</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s2$qa$, $qa$jarkom-p2$qa$, $qa$1. Konsep Arsitektur Berlapis$qa$, $qa$</section>

            <section>
                <h3>Mengapa Membutuhkan Model Referensi?</h3>
                <div>
                    <p>Komunikasi antar dua komputer yang berjauhan adalah proses yang luar biasa kompleks.</p>
                    <p>Memecahkan satu masalah besar (misal: mengirim email ke benua lain) menjadi beberapa sub-masalah
                        kecil dan independen adalah esensi dari <strong>Arsitektur Berlapis (Layered
                            Architecture)</strong>.</p>
                </div>
            </section>

            <section>
                <h3>Analogi Pengiriman Surat</h3>
                <div>
                    <div>
                        <p>Analogi Maria dan Ann yang saling berkirim surat.</p>
                        <ul>
                            <li><strong>Layer 3 (Pengirim):</strong> Maria menulis surat, memasukkannya
                                ke amplop.</li>
                            <li><strong>Layer 2 (Kurir Pos):</strong> Tukang pos mengambil surat dari
                                kotak pos dan membawanya ke kantor pos.</li>
                            <li><strong>Layer 1 (Fisik):</strong> Surat dipilah dan diterbangkan dengan
                                pesawat / truk.</li>
                        </ul>
                        <p>*Maria (Layer 3) tidak
                            peduli apakah surat diangkut pesawat atau kapal (Layer 1).</p>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/assets/postal_layers_1788845702371.jpg" alt="Analogi Kantor Pos">
                    </div>
                </div>
            </section>

            <section>
                <h3>Keuntungan Modularitas Layer</h3>
                <div>
                    <ul>
                        <li><strong>Pengembangan Independen:</strong> Insinyur pembuat fiber
                            optik tidak perlu tahu cara kerja browser Chrome.</li>
                        <li><strong>Interoperabilitas:</strong> Perangkat vendor Cisco dan
                            Mikrotik bisa nyambung asalkan mematuhi standar layer yang sama.</li>
                        <li><strong>Pemeliharaan Mudah:</strong> Mengganti jaringan rumah dari
                            kabel tembaga ke fiber (Layer 1 berubah) tidak memaksa Anda mengubah aplikasi WhatsApp
                            (Layer atas).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Konsep Peer-to-Peer Process</h3>
                <div>
                    <div>
                        <p>Komunikasi seolah-olah terjadi <strong>secara logis</strong> antara layer yang sama di dua
                            mesin.</p>
                        <ul>
                            <li>Browser PC Anda (Layer 7) merasa sedang ngobrol langsung dengan Web Server (Layer 7).
                            </li>
                            <li>Kenyataannya, secara <strong>fisik</strong>, data bergerak vertikal turun dari PC Anda
                                ke kabel, merambat, lalu naik lagi ke Server.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/assets/peer_to_peer_osi_1788846772674.jpg" alt="Peer to Peer Communication">
                    </div>
                </div>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s3$qa$, $qa$jarkom-p2$qa$, $qa$3. Enkapsulasi & Dekapsulasi Data$qa$, $qa$</section>

            <section>
                <h3>Enkapsulasi & Dekapsulasi</h3>
                <img src="https://informatika-itera.github.io/jarkom/assets/encapsulation_osi_1788846756700.jpg" alt="Encapsulation OSI">
                
            </section>

            <section>
                <h3>Detail Proses Enkapsulasi (Turun)</h3>
                <div>
                    <p>Proses pembungkusan data saat mengalir dari Layer Atas ke Layer Bawah (Pengirim):</p>
                    <ol>
                        <li><strong>Layer 7, 6, 5:</strong> Pesan atau file murni dibentuk. Disebut
                            <em>Data/Message</em>.
                        </li>
                        <li><strong>Layer 4 (Transport):</strong> Data turun, ditambahkan
                            <strong>Header L4</strong> (berisi Port sumber & tujuan). Jadilah <em>Segment</em>.
                        </li>
                        <li><strong>Layer 3 (Network):</strong> Segment turun, ditambahkan
                            <strong>Header L3</strong> (berisi IP Address asal & tujuan). Jadilah <em>Packet</em>.
                        </li>
                        <li><strong>Layer 2 (Data Link):</strong> Packet turun, ditambahkan
                            <strong>Header L2</strong> (berisi MAC Address) DAN <strong>Trailer L2</strong> (untuk
                            pengecekan error). Jadilah <em>Frame</em>.
                        </li>
                        <li><strong>Layer 1 (Physical):</strong> Frame diubah menjadi aliran
                            <em>Bits</em> (0 dan 1) untuk dikirim via media fisik.
                        </li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Detail Proses Dekapsulasi (Naik)</h3>
                <div>
                    <p>Proses pembongkaran paket saat mengalir dari Layer Bawah ke Layer Atas (Penerima):</p>
                    <ol>
                        <li><strong>Layer 1 (Physical):</strong> Sinyal fisik diterima, diterjemahkan
                            kembali menjadi <em>Bits</em>, dan diserahkan ke Layer 2.</li>
                        <li><strong>Layer 2 (Data Link):</strong> Mengecek Trailer untuk error. Jika
                            aman dan MAC Address cocok, <strong>Header & Trailer L2 dibuang</strong>, lalu isinya
                            diserahkan ke Layer 3.</li>
                        <li><strong>Layer 3 (Network):</strong> Mengecek IP Address. Jika cocok,
                            <strong>Header L3 dibuang</strong>, lalu isinya diserahkan ke Layer 4.
                        </li>
                        <li><strong>Layer 4 (Transport):</strong> Mengecek Port Address. <strong>Header
                                L4 dibuang</strong>, potongan-potongan disatukan, lalu diserahkan ke aplikasi yang
                            tepat.</li>
                        <li><strong>Layer 7, 6, 5:</strong> Data murni diproses dan akhirnya
                            ditampilkan di layar pengguna.</li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Terminologi PDU (Protocol Data Unit)</h3>
                <div>
                    <table>
                        <tr>
                            <th>Layer</th>
                            <th>Nama Data (PDU)</th>
                        </tr>
                        <tr>
                            <td>Layer 7, 6, 5</td>
                            <td><strong>Message / Data</strong></td>
                        </tr>
                        <tr>
                            <td>Layer 4</td>
                            <td><strong>Segment (TCP) / Datagram (UDP)</strong></td>
                        </tr>
                        <tr>
                            <td>Layer 3</td>
                            <td><strong>Packet / Datagram</strong></td>
                        </tr>
                        <tr>
                            <td>Layer 2</td>
                            <td><strong>Frame</strong></td>
                        </tr>
                        <tr>
                            <td>Layer 1</td>
                            <td><strong>Bits</strong></td>
                        </tr>
                    </table>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s4$qa$, $qa$jarkom-p2$qa$, $qa$4. Model TCP/IP$qa$, $qa$<p>Penguasa Internet Modern</p>
            </section>

            <section>
                <h3>Sejarah TCP/IP</h3>
                <div>
                    <ul>
                        <li>Dibuat oleh Vint Cerf & Bob Kahn dari militer AS (ARPANET) jauh sebelum OSI ada.</li>
                        <li>Karena sudah duluan matang dan terbukti, internet dunia sepakat menggunakan arsitektur
                            TCP/IP alih-alih standar teoretis OSI.</li>
                        <li>Merupakan Model yang lebih praktis (hanya 4 atau 5 layer).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>4 Lapisan Asli TCP/IP (Versi DoD)</h3>
                <div>
                    <ol>
                        <li><strong>Application Layer</strong> (Gabungan Layer 5,6,7 OSI).</li>
                        <li><strong>Transport Layer</strong> (Sama dengan OSI).</li>
                        <li><strong>Internet Layer</strong> (Ekuivalen Network Layer Layer 3 OSI).</li>
                        <li><strong>Network Access Layer</strong> (Gabungan Layer 1 dan 2 OSI).</li>
                    </ol>
                    <p>*Banyak literatur modern memecah layer terbawah jadi dua,
                        sehingga jadi model hybrid 5 Layer.*</p>
                </div>
            </section>

            <section>
                <h3>TCP/IP: Network Access Layer</h3>
                <div>
                    <p>Ekuivalen dengan Data Link + Physical.</p>
                    <p>Rahasia TCP/IP adalah dia <strong>tidak mengatur secara spesifik</strong> layer bawah ini. TCP/IP
                        dirancang untuk bisa jalan menumpang di atas teknologi hardware apapun (Ethernet kuno, Wi-Fi
                        modern, kabel fiber terbaru) tanpa masalah.</p>
                </div>
            </section>

            <section>
                <h3>TCP/IP: Internet Layer</h3>
                <div>
                    <p>Raja di layer ini adalah protokol <strong>IP (Internet Protocol)</strong>.</p>
                    <ul>
                        <li>Sifat IP adalah <em>Best-Effort Delivery</em> (Berusaha ngirim sebisa mungkin, tapi kalau
                            paketnya hilang, IP tidak akan mengulang pengiriman).</li>
                        <li>Protokol pembantunya: ICMP (untuk Ping), ARP (cari MAC Address).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>TCP/IP: Transport Layer</h3>
                <div>
                    <h4>1. TCP (Transmission Control Protocol)</h4>
                    <p><em>Reliable</em> (pasti sampai tanpa rusak). Jika ada cacat atau paket hilang, TCP menuntut
                        retransmisi. Lambat tapi presisi. (Dipakai Web HTTP, Email).</p>
                    <h4>2. UDP (User Datagram Protocol)</h4>
                    <p><em>Unreliable</em>. Tidak ada garansi paket sampai. Jika hilang, lupakan saja. Keunggulannya
                        adalah SUPER CEPAT. (Dipakai untuk Zoom Call, Game FPS, DNS).</p>
                </div>
            </section>

            <section>
                <h3>TCP/IP: Application Layer</h3>
                <div>
                    <ul>
                        <li>Segala urusan Session dan Presentation diserahkan kepada <em>programmer</em> aplikasinya
                            sendiri. Sistem operasi jaringan lepas tangan.</li>
                        <li>Ini membuat pembuatan aplikasi lebih gesit dan praktis.</li>
                        <li>Contoh protokolnya: HTTP, SMTP, FTP, DNS.</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s5$qa$, $qa$jarkom-p2$qa$, $qa$5. Perbandingan OSI vs TCP/IP$qa$, $qa$</section>

            <section>
                <h3>Perbandingan OSI vs TCP/IP</h3>
                <div>
                    <div>
                        <h4>OSI 7 Layer</h4>
                        <div>7. Application</div>
                        <div>6. Presentation</div>
                        <div>5. Session</div>
                        <div>4. Transport</div>
                        <div>3. Network</div>
                        <div>2. Data Link</div>
                        <div>1. Physical</div>
                    </div>
                    <div>
                        <h4>TCP/IP 4 Layer</h4>
                        <div>
                            Application</div>
                        <div>Transport</div>
                        <div>Internet</div>
                        <div>
                            Network Access</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Perbedaan Konseptual (Teori vs Praktek)</h3>
                <div>
                    <p><strong>Model OSI (Pecinta Teori):</strong></p>
                    <p>Model ini dirancang <em>dulu</em> secara sangat rapi, barulah ilmuwan pusing memikirkan cara
                        bikin protokolnya.</p>
                    <p><strong>Model TCP/IP (Pekerja Praktek):</strong></p>
                    <p>Protokolnya dibikin dan dipakai <em>dulu</em> sampai berhasil jalan, barulah arsitekturnya
                        dituliskan jadi standar.</p>
                </div>
            </section>

            <section>
                <h3>Mengapa OSI Gagal Mendominasi? (Bag. 1)</h3>
                <div>
                    <ul>
                        <li><strong>Waktu yang Terlambat:</strong> Saat buku standar OSI baru
                            dicetak (1984), kampus-kampus dan perusahaan di Amerika sudah memakai TCP/IP dan tidak mau
                            pindah karena biaya ganti sistem itu triliunan.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Mengapa OSI Gagal Mendominasi? (Bag. 2)</h3>
                <div>
                    <ul>
                        <li><strong>Terlalu Kompleks:</strong> Layer 5 (Session) dan Layer 6
                            (Presentation) sering terbukti tidak berguna di mayoritas aplikasi, tapi membuat sistem
                            operasi jadi sangat berat.</li>
                        <li><strong>Software yang Lambat:</strong> Implementasi awal kode
                            program OSI sangat buruk dibanding Unix yang menanamkan TCP/IP secara gratis dan cepat.</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p2-s6$qa$, $qa$jarkom-p2$qa$, $qa$6. Empat Level Pengalamatan$qa$, $qa$<p>Addressing di dunia TCP/IP</p>
            </section>

            <section>
                <h3>Hierarki Alamat (Forouzan)</h3>
                <div>
                    <div>
                        <p>TCP/IP menggunakan 4 tipe alamat, masing-masing nyangkut di 1 layer spesifik:</p>
                        <ol>
                            <li>Physical Address (Layer 2)</li>
                            <li>Logical Address (Layer 3)</li>
                            <li>Port Address (Layer 4)</li>
                            <li>Specific Address (Layer 7)</li>
                        </ol>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/assets/address_hierarchy_forouzan_1788854793640.jpg" alt="TCP/IP Address Hierarchy">
                    </div>
                </div>
            </section>

            <section>
                <h3>1. Physical Address (MAC)</h3>
                <div>
                    <ul>
                        <li>Dikenal sebagai <strong>MAC Address</strong> (Media Access Control).</li>
                        <li>Panjangnya 48-bit heksadesimal (Misal: 07:01:02:01:2C:4B).</li>
                        <li>Ditanam mati secara fisik di kartu jaringan laptop/HP Anda oleh pabrik.</li>
                        <li>Alamat ini hanya bermakna di jaringan area lokal yang sama. Jika Anda beda negara, MAC tidak
                            berguna.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>2. Logical Address (IP)</h3>
                <div>
                    <ul>
                        <li>Dikenal sebagai <strong>IP Address</strong>.</li>
                        <li>Panjangnya 32-bit untuk IPv4 (Misal: 192.168.1.10).</li>
                        <li>Bisa berubah-ubah. Jika Anda putus dari Wi-Fi rumah dan nyambung ke Wi-Fi Starbucks, IP
                            Address Anda diganti.</li>
                        <li>Berfungsi bagaikan alamat rumah global yang dimengerti oleh seluruh router di dunia.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>3. Port Address (Aplikasi)</h3>
                <div>
                    <ul>
                        <li>Angka 16-bit (contoh: Port 80, 443, 21).</li>
                        <li>Karena 1 IP Address bisa membuka Browser, Zoom, dan Spotify sekaligus. Alamat IP saja tidak
                            cukup!</li>
                        <li>Port Address memastikan paket "Masuk dari IP rumah, lanjut masuk ke kamar/aplikasi Spotify
                            dengan port yang tepat".</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>4. Specific Address (Human Readable)</h3>
                <div>
                    <p>Alamat ini diciptakan murni untuk kenyamanan memori manusia (Application Layer).</p>
                    <ul>
                        <li>Contoh: Alamat email <code>jaringan@itera.ac.id</code>.</li>
                        <li>Contoh: URL <code>www.google.com</code>.</li>
                        <li>Sistem DNS akan menerjemahkan nama ini ke angka IP Address.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Rangkuman Pertemuan 2</h3>
                <div>
                    <ul>
                        <li>Layering membagi masalah jaringan besar jadi tugas spesifik modular.</li>
                        <li>OSI Model punya 7 layer teoritis yang baik untuk media ajar akademik.</li>
                        <li>TCP/IP Model punya 4/5 layer yang memenangkan peperangan dan menjadi nyawa internet asli.
                        </li>
                        <li>Data dibungkus dari atas ke bawah (Enkapsulasi) dengan Header MAC, IP, dan Port.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3><i></i> Tugas Pertemuan 2</h3>
                <div>
                    <p><strong>Tujuan:</strong> Membuktikan teori Hierarki Alamat dan Enkapsulasi di dunia nyata.
                        <br><em>(Tugas ini membutuhkan data real-time dari
                            network lokal Anda)</em>
                    </p>
                    <ol>
                        <li>Install dan jalankan aplikasi <strong>Wireshark</strong> di laptop Anda.</li>
                        <li>Mulai proses <em>Capture</em> jaringan, lalu buka browser dan akses sebuah website, contoh
                            <code>www.itera.ac.id</code>.
                        </li>
                        <li>Hentikan <em>Capture</em>. Filter dan temukan <strong>1 buah paket</strong> TCP/TLS/HTTP
                            yang menuju server tersebut.</li>
                        <li><strong>Analisis Paket:</strong> Bedah layer paket tersebut di Wireshark, temukan dan
                            <em>screenshot</em> letak ke-4 Hierarki Alamat ini:
                            <ul>
                                <li><strong>Physical (L2):</strong> MAC Address asal (Laptop Anda) & tujuan (Gateway
                                    Anda).</li>
                                <li><strong>Logical (L3):</strong> IP Address asal (Laptop Anda) & tujuan (Server
                                    ITERA).</li>
                                <li><strong>Port (L4):</strong> Source Port (Dinamis) & Destination Port (80/443).</li>
                                <li><strong>Specific (L7):</strong> Hostname/URL yang diakses (misal pada layer
                                    TLS/HTTP).</li>
                            </ul>
                        </li>
                        <li>Kumpulkan dalam format PDF berisi <em>screenshot</em> asli dari PC Anda yang sudah diberi
                            kotak penanda (highlight).</li>
                    </ol>
                </div>
            </section>

            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-c1$qa$, $qa$jarkom-p2$qa$, $qa$checkpoint$qa$, $qa$Urutan lapisan OSI dari paling bawah adalah...$qa$, $qa$["Aplikasi, Presentasi, Sesi", "Network, Transport, Fisik", "Fisik, Data Link, Network, Transport, Sesi, Presentasi, Aplikasi", "Data Link, Fisik, Aplikasi"]$qa$::jsonb, 2, $qa$OSI dari bawah: Fisik, Data Link, Network, Transport, Sesi, Presentasi, Aplikasi.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-c2$qa$, $qa$jarkom-p2$qa$, $qa$checkpoint$qa$, $qa$Saat data turun dari lapisan atas ke bawah, proses penambahan header disebut...$qa$, $qa$["Dekapsulasi", "Fragmentasi", "Enkapsulasi", "Modulasi"]$qa$::jsonb, 2, $qa$Enkapsulasi = data dibungkus header lapisan di bawahnya; naik lagi = dekapsulasi.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-c3$qa$, $qa$jarkom-p2$qa$, $qa$checkpoint$qa$, $qa$PDU (unit data) pada lapisan Transport disebut...$qa$, $qa$["Frame", "Paket", "Bit", "Segment"]$qa$::jsonb, 3, $qa$Transport = segment, Network = paket, Data Link = frame, Fisik = bit.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-b1$qa$, $qa$jarkom-p2$qa$, $qa$battle$qa$, $qa$Dalam mnemonic 'Please Do Not Throw Sausage Pizza Away', lapisan 'Not' adalah...$qa$, $qa$["Network (3) dengan PDU packet", "Network (4) dengan PDU segment", "Data Link (2) dengan PDU frame", "Transport (3) dengan PDU datagram"]$qa$::jsonb, 0, $qa$'Not' = Network, lapisan ke-3 dari bawah, PDU-nya packet/datagram.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-b2$qa$, $qa$jarkom-p2$qa$, $qa$battle$qa$, $qa$Saat data turun dari application layer ke physical layer, yang terjadi adalah...$qa$, $qa$["Setiap layer menghapus header layer di bawahnya", "Setiap layer menambahkan header-nya sendiri ke data", "Hanya layer network yang menambahkan header", "Data dikirim apa adanya tanpa tambahan informasi kontrol"]$qa$::jsonb, 1, $qa$Itulah enkapsulasi; di sisi penerima terjadi dekapsulasi: tiap layer membaca lalu membuang headernya.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-b3$qa$, $qa$jarkom-p2$qa$, $qa$battle$qa$, $qa$Mengapa TCP/IP akhirnya mendominasi padahal OSI adalah standar resmi ISO?$qa$, $qa$["Karena OSI hanya punya 4 layer", "Karena TCP/IP sudah matang dan dipakai luas sebelum standar OSI selesai", "Karena TCP/IP dibuat oleh ISO", "Karena OSI tidak mendukung wireless"]$qa$::jsonb, 1, $qa$TCP/IP lahir dari ARPANET dan sudah terlanjur dipakai saat standar OSI (1984) terbit; ditambah OSI dinilai terlalu kompleks.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-b4$qa$, $qa$jarkom-p2$qa$, $qa$battle$qa$, $qa$Laptop Anda menerima paket. Bagaimana sistem tahu paket itu untuk aplikasi Zoom dan bukan Spotify?$qa$, $qa$["Berdasarkan MAC address", "Berdasarkan IP address", "Berdasarkan port address di transport layer", "Berdasarkan nama host pengirim"]$qa$::jsonb, 2, $qa$Port address (16-bit) di layer transport mengarahkan segmen ke soket aplikasi yang tepat.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p2-b5$qa$, $qa$jarkom-p2$qa$, $qa$battle$qa$, $qa$Anda pindah dari Wi-Fi rumah ke Wi-Fi kampus. Alamat mana yang BERUBAH?$qa$, $qa$["MAC address laptop", "IP address laptop", "OUI pada NIC", "Alamat email Anda"]$qa$::jsonb, 1, $qa$MAC address permanen tertanam di NIC; IP address bersifat logis dan berubah mengikuti jaringan.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
