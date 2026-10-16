insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p4$qa$, $qa$jarkom$qa$, $qa$Lapisan Data Link$qa$, $qa$<h3>Layanan Data Link</h3>
<ul>
<li><strong>Framing:</strong> membungkus datagram jadi frame (header + trailer) dengan batas awal-akhir jelas.</li>
<li><strong>Error detection & correction:</strong> deteksi bit rusak lalu minta kirim ulang atau koreksi.</li>
<li><strong>Link access:</strong> mengatur siapa boleh kirim di medium bersama (protokol MAC).</li>
<li><strong>Flow control:</strong> selaraskan kecepatan pengirim-penerima agar buffer tak penuh.</li>
<li>Diimplementasikan di <strong>NIC</strong> pada setiap host & perangkat jaringan.</li>
</ul>
<h3>Struktur Frame Ethernet</h3>
<p>Preamble (8B) | MAC tujuan (6B) | MAC sumber (6B) | Type (2B) | Data 46-1500B | CRC (4B). Overhead total 26 byte; type 0x0800 = IPv4, 0x0806 = ARP, 0x86DD = IPv6.</p>
<h3>Deteksi Error</h3>
<table>
<tr><th>Teknik</th><th>Cara kerja</th><th>Kekuatan</th></tr>
<tr><td>Parity bit</td><td>Tambah 1 bit agar jumlah bit 1 genap/ganjil</td><td>Deteksi error ganjil; versi 2 dimensi bisa koreksi 1 bit</td></tr>
<tr><td>Checksum</td><td>Jumlahkan blok 16-bit (1's complement)</td><td>Cepat di software; dipakai UDP/TCP/IP</td></tr>
<tr><td>CRC</td><td>Bagi polinomial dengan generator yang disepakati</td><td>Paling kuat; dipakai Ethernet, Wi-Fi, USB</td></tr>
</table>
<h3>Multiple Access Protocol</h3>
<ul>
<li><strong>Channel partitioning:</strong> TDMA (slot waktu), FDMA (pita frekuensi), CDMA (kode unik) — tanpa collision tapi boros saat sepi.</li>
<li><strong>Random access:</strong> kirim kapan saja; ALOHA, <strong>CSMA</strong> (dengar dulu), <strong>CSMA/CD</strong> (dengar sambil kirim, hentikan saat tabrakan — untuk Ethernet kabel), <strong>CSMA/CA</strong> (hindari tabrakan — untuk Wi-Fi).</li>
<li><strong>Taking turns:</strong> polling & token — giliran teratur, tanpa collision.</li>
</ul>
<h3>MAC Address & ARP</h3>
<ul>
<li><strong>MAC 48-bit</strong> heksadesimal (mis. 1A:2F:BB:76:09:AD): 3 byte OUI (produsen) + 3 byte serial; permanen di NIC. MAC itu seperti NIK, IP seperti alamat rumah.</li>
<li><strong>ARP</strong> memetakan IP ke MAC dalam satu subnet: broadcast query, unicast reply, disimpan di tabel ber-TTL.</li>
<li><strong>Kunci:</strong> IP tujuan tidak berubah sepanjang perjalanan, tetapi MAC tujuan ditulis ulang di setiap hop.</li>
</ul>
<h3>Ethernet & Switch</h3>
<ul>
<li>Ethernet (Xerox PARC 1973, IEEE 802.3): connectionless & unreliable; 10 Mbps hingga 400 Gbps.</li>
<li><strong>Switch</strong> belajar otomatis (self-learning): catat MAC sumber, forward ke port tepat, flood bila tak dikenal, filter bila satu segmen. Tiap port = collision domain sendiri, full-duplex.</li>
<li><strong>Switch (L2/MAC)</strong> untuk dalam satu subnet — murah & plug-and-play; <strong>router (L3/IP)</strong> untuk antar subnet — butuh konfigurasi.</li>
</ul>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan04.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 4) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s1$qa$, $qa$jarkom-p4$qa$, $qa$Lapisan Data Link$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>

            
            <section>
                <div>
                    
                    <h3>Pertemuan 4</h3>
                </div>
                <p>Referensi: Kurose &amp; Ross — <em>Computer Networking: A Top-Down Approach (8th Ed)</em><br>
                    &amp; Forouzan — <em>Data Communications and Networking (5th Ed)</em></p>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
                <aside>Selamat pagi/siang. Hari ini kita naik satu lapisan dari Physical ke Data Link.
                    Lapisan ini yang bertanggung jawab atas pengiriman frame antar perangkat yang berdekatan
                    (hop-by-hop).</aside>
            </section>

            
            <section>
                <h3>Outline Materi</h3>
                <div>
                    <div>
                        <p>Bagian 1: Layanan &amp; Error Handling</p>
                        <ul>
                            <li>Layanan Lapisan Data Link</li>
                            <li>Framing &amp; Struktur Frame</li>
                            <li>Deteksi Error: Parity, Checksum, CRC</li>
                            <li>Kontrol Aliran &amp; Koreksi Error</li>
                        </ul>
                    </div>
                    <div>
                        <p>Bagian 2: MAC &amp; Jaringan LAN</p>
                        <ul>
                            <li>Multiple Access Protocols (ALOHA, CSMA)</li>
                            <li>MAC Address &amp; ARP</li>
                            <li>Ethernet &amp; Frame Ethernet</li>
                            <li>Switch: Self-Learning &amp; Forwarding</li>
                            <li>Switch vs Router</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Analogi: Data Link di Kehidupan Nyata</h3>
                <div>
                    <div>
                        <p>Bayangkan perjalanan <strong>Denpasar → Bandung</strong>:</p>
                        <ul>
                            <li>🚖 <strong>Limo</strong>: Denpasar → Ngurah Rai (Bandara)</li>
                            <li>✈️ <strong>Pesawat</strong>: Ngurah Rai → Soetta (Jakarta)</li>
                            <li>🚄 <strong>Kereta</strong>: Jakarta → Bandung</li>
                        </ul>
                        <div>
                            <strong>Analogi Jaringan:</strong>
                            <ul>
                                <li>👤 Penumpang = <strong>Datagram</strong> (paket data)</li>
                                <li>🎫 Tiket per segmen = <strong>Frame</strong> per link</li>
                                <li>🏣 Terminal transportasi = <strong>Router / Switch</strong></li>
                                <li>Pengemudi/pilot = <strong>Link-layer protocol</strong></li>
                            </ul>
                            <p>Tiap "kendaraan" yang berbeda = tiap link bisa
                                punya protokol berbeda (Ethernet, Wi-Fi, PPP, dll).</p>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/analogi_datalink.jpg" alt="Analogi perjalanan Datagram dari Sumber ke Tujuan melewati berbagai link">
                        <p>Datagram melewati beberapa link berbeda</p>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s2$qa$, $qa$jarkom-p4$qa$, $qa$1. Layanan Lapisan Data Link$qa$, $qa$<aside>Data link bertanggung jawab atas pengiriman frame antar node yang terhubung
                    langsung (satu hop). Ini berbeda dengan network layer yang mengurus ujung-ke-ujung.</aside>
            </section>

            
            <section>
                <h3>Layanan Data Link: Framing</h3>
                <div>
                    <div>
                        <div>Framing</div>
                        <div>
                            <ul>
                                <li>Mengemas datagram dari Network Layer ke dalam sebuah <strong>frame</strong> dengan
                                    menambahkan <em>header</em> dan <em>trailer</em>.</li>
                                <li>Header frame berisi <strong>MAC address</strong> sumber dan tujuan — berbeda dengan
                                    IP address.</li>
                                <li>Frame menandai batas awal dan akhir data yang dikirim per satu hop.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/framing_diagram.jpg" alt="Ilustrasi Framing pada Layer Data Link">
                        <p>Proses enkapsulasi datagram menjadi frame</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Layanan Data Link: Error Detection &amp; Correction</h3>
                <div>
                    <div>
                        <div>Error Detection &amp; Correction</div>
                        <div>
                            <ul>
                                <li>Error terjadi karena atenuasi sinyal dan noise selama transmisi.</li>
                                <li>Penerima mendeteksi error, lalu meminta pengiriman ulang (<em>retransmission</em>)
                                    atau mengoreksinya sendiri.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/error_detection.jpg" alt="Ilustrasi Deteksi dan Koreksi Error pada Data Link">
                        <p>Proses penanganan error selama transmisi</p>
                    </div>
                </div>
            </section>


            
            <section>
                <h3>Layanan Data Link: Link Access</h3>
                <div>
                    <div>
                        <div>Link Access</div>
                        <div>
                            <ul>
                                <li>Mengatur <strong>siapa yang boleh mengirim</strong> pada medium bersama (<em>shared
                                        medium</em>) pada satu waktu tertentu.</li>
                                <li>Protokol yang mengatur hal ini disebut <strong>Medium Access Control (MAC)</strong>.
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/link_access.jpg" alt="Ilustrasi Medium Access Control pada Data Link">
                        <p>Protokol MAC mengatur akses pengiriman data</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Layanan Data Link: Flow Control</h3>
                <div>

                    <div>
                        <div>Flow Control (Kontrol Aliran)</div>
                        <div>
                            <ul>
                                <li>Mengendalikan laju transmisi data secara dinamis antara perangkat pengirim dan
                                    penerima yang terhubung secara langsung.</li>
                                <li>Mencegah terjadinya penumpukan data (kelebihan kapasitas memori antrean) apabila
                                    pengirim mengirimkan data lebih cepat daripada kemampuan penerima dalam
                                    memprosesnya.</li>
                            </ul>
                        </div>
                        <div>
                            💡 Mekanisme kontrol aliran ini diimplementasikan secara langsung pada perangkat keras Kartu
                            Jaringan (Network Interface Card / NIC) yang terdapat pada laptop, ponsel cerdas, dan
                            <em>router</em> Anda.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/flow_control.jpg" alt="Ilustrasi Flow Control pada Data Link Layer">
                        <p>Sinyal kontrol untuk mencegah buffer penerima penuh</p>
                    </div>
                </div>
            </section>


            
            <section>
                <h3>Implementasi: Di Mana Data Link Berada? (Part 1)</h3>
                <div>
                    <div>
                        <p>Lapisan Data Link diimplementasikan pada setiap host dan perangkat jaringan, bukan hanya di
                            server:</p>
                        <ul>
                            <li><strong>Network Interface Card (NIC)</strong> — chip di motherboard atau kartu PCI-e
                                terpisah yang mengimplementasikan lapisan link dan fisik.</li>
                            <li>NIC menghubungkan host ke link yang memungkinkan pengiriman/penerimaan frame.</li>
                        </ul>
                        <div>
                            🔌 NIC adalah "jembatan" antara dunia software (IP, TCP) dan dunia hardware (kabel, sinyal
                            listrik).
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/nic_implementation.jpg" alt="Ilustrasi Implementasi NIC pada Stack Jaringan">
                        <p>NIC mengimplementasikan lapisan Link &amp; Physical</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Implementasi: Di Mana Data Link Berada? (Part 2)</h3>
                <div>
                    <div>
                        <p>Lapisan Data Link diimplementasikan pada setiap host dan perangkat jaringan, bukan hanya di
                            server:</p>
                        <ul>
                            <li>Pada sisi pengirim: mengenkapsulasi datagram ke frame, menambahkan bit error-check.</li>
                            <li>Pada sisi penerima: memeriksa error, mengekstrak datagram, memberikannya ke network
                                layer.</li>
                        </ul>
                        <div>
                            🔌 NIC adalah "jembatan" antara dunia software (IP, TCP) dan dunia hardware (kabel, sinyal
                            listrik).
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/nic_process.jpg" alt="Proses Kerja NIC di Sisi Pengirim dan Penerima">
                        <p>Peran aktif NIC saat mengirim dan menerima data</p>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s3$qa$, $qa$jarkom-p4$qa$, $qa$2. Framing & Struktur Frame$qa$, $qa$<aside>Frame adalah unit data di lapisan data link, seperti paket di lapisan network. Mari
                    kita lihat strukturnya.</aside>
            </section>

            
            <section>
                <h3>Struktur Frame Ethernet (Part 1)</h3>
                <div>
                    <div>
                        <span>Preamble</span>
                        <span>8 byte</span>
                    </div>
                    <div>
                        <span>Dest. MAC</span>
                        <span>6 byte</span>
                    </div>
                    <div>
                        <span>Source MAC</span>
                        <span>6 byte</span>
                    </div>
                    <div>
                        <span>Type</span>
                        <span>2 byte</span>
                    </div>
                    <div>
                        <span>Data (Payload)</span>
                        <span>46–1500 byte</span>
                    </div>
                    <div>
                        <span>CRC</span>
                        <span>4 byte</span>
                    </div>
                </div>
                <div>
                    <div>
                        <ul>
                            <li><strong>Preamble (8B):</strong> 7 byte pola 10101010 + 1 byte 10101011. Digunakan untuk
                                <em>sinkronisasi clock</em> antara pengirim dan penerima.
                            </li>
                            <li><strong>Dest. &amp; Src. MAC (6B each):</strong> Alamat fisik hardware tujuan dan sumber
                                (48-bit).</li>
                            <li><strong>Type (2B):</strong> Menunjukkan protokol di layer atas — 0x0800 = IPv4, 0x0806 =
                                ARP, 0x86DD = IPv6.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/frame_structure_p1.jpg" alt="Ilustrasi tiga field pertama pada Frame Ethernet">
                        <p>Fungsi Preamble, Alamat MAC, dan Tipe</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Struktur Frame Ethernet (Part 2)</h3>
                <div>
                    <div>
                        <span>Preamble</span>
                        <span>8 byte</span>
                    </div>
                    <div>
                        <span>Dest. MAC</span>
                        <span>6 byte</span>
                    </div>
                    <div>
                        <span>Source MAC</span>
                        <span>6 byte</span>
                    </div>
                    <div>
                        <span>Type</span>
                        <span>2 byte</span>
                    </div>
                    <div>
                        <span>Data (Payload)</span>
                        <span>46–1500 byte</span>
                    </div>
                    <div>
                        <span>CRC</span>
                        <span>4 byte</span>
                    </div>
                </div>
                <div>
                    <div>
                        <ul>
                            <li><strong>Data / Payload (46–1500B):</strong> Berisi datagram IP yang dienkapsulasi.
                                Minimum 46B — jika kurang, ditambah <em>padding</em>. Maksimum 1500B (MTU Ethernet).
                            </li>
                            <li><strong>CRC (4B):</strong> Cyclic Redundancy Check — nilai hash dari isi frame untuk
                                mendeteksi error transmisi. Jika CRC tidak cocok, frame dibuang.</li>
                        </ul>
                        <div>
                            Total overhead frame: 8+6+6+2+4 = <strong>26 byte</strong>. Data murni maksimal 1500/1526 ≈
                            98.3% efisiensi.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/frame_structure_p2.jpg" alt="Ilustrasi Data/Payload dan CRC pada Frame Ethernet">
                        <p>Fungsi Data/Payload dan CRC</p>
                    </div>
                </div>
            </section>
            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s4$qa$, $qa$jarkom-p4$qa$, $qa$3. Deteksi Error$qa$, $qa$<aside>Ada tiga teknik utama deteksi error yang perlu dipahami: Parity Check, Internet
                    Checksum, dan CRC.</aside>
            </section>

            
            <section>
                <h3>Konsep Error Detection &amp; Correction (EDC)</h3>
                <div>
                    <div>
                        <p>Bit error dapat terjadi selama transmisi karena atenuasi, noise, dan interferensi.</p>
                        <div>
                            <strong>D</strong> = Data yang dilindungi (termasuk header)<br>
                            <strong>EDC</strong> = Bit error-detection &amp; correction (redundansi)<br><br>
                            Pengirim kirim: <strong>D + EDC</strong><br>
                            Penerima terima: <strong>D' + EDC'</strong> (mungkin berubah)<br>
                            Penerima cek: apakah D' konsisten dengan EDC'?
                        </div>
                        <div>
                            ⚠️ Error detection <strong>tidak 100% reliable</strong>! Ada kemungkinan error tidak
                            terdeteksi (undetected error) — probabilitasnya tergantung teknik yang dipakai.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/edc_concept.jpg" alt="Ilustrasi Konsep Error Detection and Correction">
                        <p>Proses logika verifikasi error pada data</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Teknik 1: Parity Checking</h3>
                <div>
                    <div>
                        <div>Single Bit Parity</div>
                        <div>
                            <p>Menambahkan <strong>1 bit paritas</strong> sehingga total bit 1 dalam data menjadi genap
                                (<em>even parity</em>) atau ganjil (<em>odd parity</em>).</p>
                            <div>
                                Data: 0111000110101011<br>
                                Paritas: <span>1</span> (ada 9 bit '1' → tambah
                                1 agar genap)<br>
                                Dikirim: 0111000110101011<span>1</span>
                            </div>
                            <ul>
                                <li>✅ Deteksi error <strong>ganjil (1, 3, 5, ...)</strong> bit yang berubah.</li>
                                <li>❌ Tidak bisa deteksi error genap (2, 4, ... bit berubah sekaligus).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Two-Dimensional Parity</div>
                        <div>
                            <p>Data disusun dalam matriks baris-kolom. Bit paritas dihitung per baris <em>dan</em> per
                                kolom.</p>
                            <div>
                                1 0 1 1 0 | <span>1</span><br>
                                0 1 0 1 1 | <span>1</span><br>
                                1 1 0 1 0 | <span>1</span><br>
                                <span>0 0 1 1 1 | <span>1</span></span>
                            </div>
                            <ul>
                                <li>✅ Bisa mendeteksi <strong>dan mengoreksi</strong> single-bit error (tahu baris &amp;
                                    kolom yang salah).</li>
                                <li>✅ Mendeteksi semua kombinasi 2-bit error.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Studi Kasus: Single Bit Parity (Even Parity)</h3>
                <div>
                    <div>
                        <div>1. Sisi Pengirim (Sender)</div>
                        <p>Katakanlah kita ingin mengirim karakter
                            <strong>'A'</strong>. Dalam kode ASCII (7-bit), nilainya adalah: <code>1000001</code>
                        </p>
                        <ul>
                            <li>Kita menggunakan aturan <strong>Even Parity</strong> (jumlah total bit '1' harus genap).
                            </li>
                            <li>Hitung jumlah bit '1' pada data asli: Ada <strong>dua</strong> buah bit '1' (sudah
                                genap).</li>
                            <li>Maka, Bit Paritas yang ditambahkan adalah: <strong>0</strong>.</li>
                        </ul>
                        <div>
                            Dikirim = 1000001 <span>0</span>
                        </div>
                    </div>
                    <div>
                        <div>2. Sisi Penerima (Receiver)
                        </div>
                        <p>Misalkan terjadi <em>noise</em> saat transmisi
                            sehingga bit paling kiri berubah dari 1 menjadi 0. Data yang diterima:
                            <code><span>0</span>000001 0</code>
                        </p>
                        <ul>
                            <li>Penerima mengetahui aturan <strong>Even Parity</strong>.</li>
                            <li>Penerima menghitung ulang total bit '1' pada bingkai yang diterima.</li>
                            <li>Jumlah bit '1' sekarang = <strong>Satu</strong> (bernilai ganjil).</li>
                        </ul>
                        <div>
                            ❌ <strong>ERROR TERDETEKSI!</strong> Karena aturan mensyaratkan jumlah genap namun hasilnya
                            ganjil, penerima tahu bahwa data telah rusak dan akan membuangnya.
                        </div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Studi Kasus: Two-Dimensional Parity (Koreksi)</h3>
                <div>
                    <div>
                        <div>1. Pengirim (Menyusun Matriks)
                        </div>
                        <p>Data asli dibagi menjadi matriks. Hitung paritas
                            genap (<em>even parity</em>) untuk tiap baris dan tiap kolom.</p>
                        <div>
                            <span>(Data)</span>&nbsp;&nbsp;&nbsp;&nbsp;| <span>Baris</span><br>
                            1 0 1 1 0 | <span>1</span><br>
                            0 1 0 1 1 | <span>1</span><br>
                            1 1 0 1 0 | <span>1</span><br>
                            -----------+---<br>
                            <span>0 0 1 1 1</span> | <span>1</span>
                        </div>
                        <ul>
                            <li><span>Orange</span>: Bit Paritas per Baris.</li>
                            <li><span>Biru</span>: Bit Paritas per Kolom.</li>
                            <li><span>Ungu</span>: Paritas dari baris &amp; kolom paritas.</li>
                        </ul>
                    </div>
                    <div>
                        <div>2. Penerima (Deteksi &amp;
                            Koreksi)</div>
                        <p>Terjadi <em>noise</em>! Bit pada <strong>Baris
                                2, Kolom 2</strong> berubah menjadi `0`.</p>
                        <div>
                            1 0 1 1 0 | 1 &nbsp;&nbsp;(Benar! &rarr; Baris)<br>
                            0 <span>0</span> 0 1 1 | 1
                            &nbsp;&nbsp;<span>(Salah! &rarr; Baris)</span><br>
                            1 1 0 1 0 | 1 &nbsp;&nbsp;(Benar! &rarr; Baris)<br>
                            -----------+----------------------<br>
                            0 <span>0</span> 1 1 1 | 1&nbsp;&nbsp;(Salah! &rarr; Kolom 2)<br>
                            &nbsp;&nbsp;&uarr;<br>
                            <span>(Salah! &rarr; Kolom)</span>
                        </div>
                        <ul>
                            <li>Baris ke-2 terdeteksi ganjil ❌</li>
                            <li>Kolom ke-2 terdeteksi ganjil ❌</li>
                        </ul>
                        <div>
                            ✅ <strong>KOREKSI BERHASIL!</strong> Persilangan baris ke-2 dan kolom ke-2 menunjukkan letak
                            <em>error</em> secara pasti. Penerima cukup mengembalikan <code>0</code> menjadi
                            <code>1</code>.
                        </div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Teknik 2: Cyclic Redundancy Check (CRC)</h3>
                <div>
                    <div>
                        <div>Prinsip CRC</div>
                        <div>
                            <ul>
                                <li><strong>D</strong> = data bits (sebagai bilangan biner).</li>
                                <li><strong>G</strong> = generator polynomial (r+1 bit, disepakati pengirim &amp;
                                    penerima).</li>
                                <li>Pengirim menghitung <strong>R</strong> (r bit) sedemikian sehingga:<br>
                                    <code>D·2ʳ XOR R</code>
                                    habis dibagi G tanpa sisa.
                                </li>
                                <li>Penerima membagi <code>D'·2ʳ XOR R'</code>
                                    dengan G. Jika sisa ≠ 0 → error terdeteksi.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Contoh CRC</div>
                        <div>
                            <div>
                                D = 101110 (data, 6 bit)<br>
                                G = 1001 (generator, 4 bit → r=3)<br>
                                <br>
                                D·2³ = 101110<span>000</span><br>
                                Bagi dengan G (long division XOR):<br>
                                R = <span>011</span><br>
                                <br>
                                Dikirim: 101110<span>011</span>
                            </div>
                            <div>
                                ✅ CRC digunakan di <strong>Ethernet, Wi-Fi, USB, Bluetooth</strong> karena kemampuannya
                                mendeteksi burst error.
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    CRC 32-bit (CRC-32) yang dipakai Ethernet mampu mendeteksi semua burst error ≤ 32 bit, dan sebagian
                    besar burst error yang lebih panjang.
                </div>
            </section>
            <section>
                <h3>Contoh Penerapan CRC</h3>
                <div>
                    <div>
                        <div>Di Sisi Pengirim</div>
                        <div>
                            <p><strong>D:</strong> 101110 | <strong>G:</strong> 1001 (r=3)</p>
                            <div>
                                <b>1. Tambah r bit 0:</b> 101110<span>000</span><br><br>
                                <b>2. Bagi (XOR) dengan G:</b><br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__________________<br>
                                &nbsp;&nbsp;1001&nbsp;&nbsp;&nbsp;/&nbsp;1&nbsp;0&nbsp;1&nbsp;1&nbsp;1&nbsp;0&nbsp;0&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;1&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;0&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;1&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;1&nbsp;1&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;0&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;1&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;1&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>0&nbsp;1&nbsp;1</span> (R)<br><br>
                                <b>3. Dikirim:</b> D + R = 101110<span>011</span>
                            </div>
                        </div>
                    </div>
                    <div>
                        <div>Di Sisi Penerima</div>
                        <div>
                            <p><strong>Diterima:</strong> 101110<span>011</span> | <strong>G:</strong> 1001</p>
                            <div>
                                <b>1. Bagi (XOR) dengan G:</b><br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__________________<br>
                                &nbsp;&nbsp;1001&nbsp;&nbsp;&nbsp;/&nbsp;1&nbsp;0&nbsp;1&nbsp;1&nbsp;1&nbsp;0&nbsp;0&nbsp;1&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;1&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;0&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;1&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;1&nbsp;1&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;0&nbsp;0&nbsp;0&nbsp;0<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;1&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1&nbsp;0&nbsp;0&nbsp;1<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-------<br>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>0&nbsp;0&nbsp;0</span> (Sisa)<br><br>
                                <b>2. Cek Sisa:</b> Sisa = 000 &rarr; <b>TIDAK ADA ERROR</b>.
                            </div>
                        </div>
                    </div>
                </div>
            </section>


            
            <section>
                <h3>Teknik 3: Internet Checksum (Pengirim)</h3>
                <div>
                    <div>
                        <div>Cara Kerja (Pengirim)</div>
                        <ol>
                            <li>Anggap isi segmen UDP/TCP (termasuk header) sebagai deretan
                                <strong>integer 16-bit</strong>.
                            </li>
                            <li>Jumlahkan semua integer tersebut menggunakan <strong>aritmatika 1's
                                    complement</strong>.</li>
                            <li>Hasil penjumlahan di-<strong>complement</strong> (balik semua bit)
                                &rarr; ini adalah <strong>checksum</strong>.</li>
                            <li>Sisipkan nilai checksum ke dalam field checksum di header.</li>
                        </ol>
                        <div>
                            💡 Checksum digunakan di <strong>UDP &amp; TCP header</strong>, serta <strong>IP
                                header</strong>.
                            Kekuatannya lebih lemah dari CRC, tapi sangat cepat dihitung oleh <em>software</em>.
                        </div>
                    </div>
                    <div>
                        <div>
                            <p>Contoh
                                Penjumlahan (Pengirim)</p>
                            <div>
                                0110011001100110<br>
                                + 0101010101010101<br>
                                ─────────────────<br>
                                1011101110110111<br>
                                &larr; complement &rarr;<br>
                                <span>0100010001001000</span> = checksum
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Teknik 3: Internet Checksum (Penerima)</h3>
                <div>
                    <div>
                        <div>Cara Kerja (Penerima)</div>
                        <ol>
                            <li>Jumlahkan semua integer 16-bit yang diterima <em>termasuk</em> field
                                checksum yang telah disisipkan tadi.</li>
                            <li>Jika hasil penjumlahannya = <code>1111...1111</code> (semua bit 1)
                                &rarr; <strong>tidak ada error</strong>.</li>
                            <li>Jika ada satu saja bit yang bernilai 0 &rarr; <strong>error
                                    terdeteksi</strong>, segmen tersebut langsung dibuang.</li>
                        </ol>
                    </div>
                    <div>
                        <div>
                            <p>Contoh
                                Verifikasi (Penerima)</p>
                            <div>
                                1011101110110111 <span>(Hasil Jumlah)</span><br>
                                + <span>0100010001001000</span> <span>(Checksum)</span><br>
                                ─────────────────<br>
                                <span>1111111111111111</span><br>
                                &larr; Valid! &rarr;
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s5$qa$, $qa$jarkom-p4$qa$, $qa$4. Multiple Access Protocols$qa$, $qa$<aside>Ketika banyak node berbagi satu channel, bagaimana mereka mengatur giliran? Inilah
                    masalah multiple access.</aside>
            </section>

            
            <section>
                <h3>Point-to-Point vs Broadcast Link</h3>
                <div>
                    <div>
                        <div>Point-to-Point Link</div>
                        <div>
                            <ul>
                                <li>Hanya <strong>dua node</strong> yang terhubung langsung di satu link.</li>
                                <li>Tidak ada masalah "tabrakan" — channel eksklusif.</li>
                                <li>Contoh: Kabel Ethernet antara PC dan switch, PPP (dial-up modem).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Broadcast Link (Shared Medium)</div>
                        <div>
                            <ul>
                                <li><strong>Banyak node</strong> berbagi satu channel yang sama secara bersamaan.</li>
                                <li>Jika dua node kirim data serentak → <strong>Collision (tabrakan)</strong> → data
                                    rusak, tidak terbaca.</li>
                                <li>Contoh: Wi-Fi (WLAN), Ethernet bus lama (coaxial), Bluetooth.</li>
                            </ul>
                            <div>
                                ⚠️ Collision = sinyal dari 2+ sumber bercampur dan tidak dapat dibedakan. Butuh protokol
                                MAC untuk mengatur!
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <strong>MAC Protocol</strong> menentukan cara node bergantian menggunakan shared channel sehingga
                    collision dapat dihindari atau pulih dari collision dengan cepat.
                </div>
            </section>

            
            <section>
                <h3>Tiga Kelas Protokol MAC</h3>
                <div>
                    <div>
                        <p>📅 Channel
                            Partitioning</p>
                        <p>Bagi channel menjadi irisan kecil (time slot, frekuensi,
                            kode). Alokasikan irisan secara eksklusif ke tiap node.</p>
                        <ul>
                            <li>TDMA (Time Division)</li>
                            <li>FDMA (Frequency Division)</li>
                            <li>CDMA (Code Division)</li>
                        </ul>
                        <div>✅ Tanpa collision<br>❌ Wasteful
                            saat node sepi</div>
                    </div>
                    <div>
                        <p>🎲 Random Access</p>
                        <p>Node kirim kapan pun mau. Jika collision terjadi, ada
                            mekanisme deteksi &amp; retransmisi dengan waktu acak.</p>
                        <ul>
                            <li>ALOHA (Slotted &amp; Pure)</li>
                            <li>CSMA / CSMA-CD</li>
                            <li>CSMA-CA (Wi-Fi)</li>
                        </ul>
                        <div>✅ Efisien saat beban ringan<br>❌
                            Collision bisa terjadi</div>
                    </div>
                    <div>
                        <p>🎤 Taking Turns</p>
                        <p>Node bergiliran secara teratur (polling atau token).
                            Tidak ada collision, tapi ada overhead koordinasi.</p>
                        <ul>
                            <li>Polling (master-slave)</li>
                            <li>Token Ring / Token Bus</li>
                        </ul>
                        <div>✅ Efisiensi tinggi<br>❌ Single
                            point of failure (token/master)</div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Channel Partitioning: TDMA</h3>
                <div>
                    <div>
                        <div>TDMA (Time Division Multiple Access)</div>
                        <div>
                            <p>Kapasitas saluran transmisi (<em>channel</em>) tunggal dibagi berdasarkan <strong>waktu
                                    (time slot)</strong>.</p>
                            <ul>
                                <li>Tiap <em>node</em> mendapat jatah slot waktu yang tetap pada setiap putaran
                                    (<em>round</em>).</li>
                                <li><em>Node</em> yang sedang tidak memiliki data akan tetap "membuang" slot waktunya
                                    (inefisien saat lalu lintas sepi).</li>
                                <li><strong>Contoh Implementasi:</strong> Jaringan seluler 2G (GSM).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/tdma_concept.jpg" alt="Ilustrasi Pembagian Kanal TDMA">
                        <p>Transmisi data diatur ke dalam slot waktu berurutan</p>
                    </div>

                </div>
            </section>

            <section>
                <h3>Channel Partitioning: FDMA</h3>
                <div>
                    <div>
                        <div>FDMA (Frequency Division Multiple Access)</div>
                        <div>
                            <p>Kapasitas saluran transmisi dibagi berdasarkan <strong>pita frekuensi (frequency
                                    band)</strong>.</p>
                            <ul>
                                <li>Tiap <em>node</em> dialokasikan pita frekuensi eksklusif secara permanen.</li>
                                <li>Pita frekuensi dari <em>node</em> yang sedang tidak mentransmisikan data akan
                                    terbuang percuma (menjadi pita kosong/menganggur).</li>
                                <li><strong>Contoh Implementasi:</strong> Siaran Radio FM analog, jaringan seluler 1G
                                    (AMPS).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/fdma_concept.jpg" alt="Ilustrasi Pembagian Kanal FDMA">
                        <p>Transmisi data diatur ke dalam pita frekuensi terpisah</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Channel Partitioning: CDMA</h3>
                <div>
                    <div>
                        <div>CDMA (Code Division Multiple Access)</div>
                        <div>
                            <p>Kapasitas saluran tidak dibagi berdasarkan waktu atau frekuensi, melainkan berdasarkan
                                <strong>kode unik (chipping sequence)</strong>.
                            </p>
                            <ul>
                                <li>Setiap <em>node</em> diberikan sebuah kode matematika unik yang saling ortogonal
                                    (tidak mengganggu satu sama lain).</li>
                                <li>Semua <em>node</em> dapat mentransmisikan data <strong>secara bersamaan
                                        serentak</strong> pada <strong>frekuensi yang sama</strong>.</li>
                                <li>Penerima menggunakan operasi matematika (<em>dot product</em>) dengan kode yang sama
                                    untuk mengekstrak data murni dari pengirim tertentu di antara sinyal-sinyal yang
                                    tercampur.</li>
                                <li><strong>Contoh Implementasi:</strong> Jaringan seluler 3G (WCDMA), komunikasi
                                    satelit, dan militer.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/cdma_concept.jpg" alt="Ilustrasi Pembagian Kanal CDMA">
                        <p>Transmisi dicampur dengan kode unik (Chipping Sequence)</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Random Access: Slotted ALOHA</h3>
                <div>
                    <div>
                        <div>Asumsi &amp; Cara Kerja</div>
                        <div>
                            <ul>
                                <li>Semua frame berukuran sama.</li>
                                <li>Waktu dibagi ke dalam <strong>slot</strong> berukuran tetap (= waktu kirim 1 frame).
                                </li>
                                <li>Node hanya boleh mulai kirim di awal slot.</li>
                                <li>Jika <strong>collision</strong>: node retransmisi di slot berikutnya dengan
                                    <strong>probabilitas p</strong>.
                                </li>
                            </ul>
                        </div>
                        <div>Efisiensi
                            Maksimum</div>
                        <div>
                            <p>Dengan N node dan probabilitas kirim p per slot, efisiensi optimal mendekati <strong>1/e
                                    ≈ 37%</strong> saat N sangat besar.</p>
                            <div>
                                ✅ Sederhana, node aktif tunggal bisa pakai penuh channel.<br>
                                ❌ Efisiensi max hanya 37% — sangat boros!
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/slotted_aloha_concept.jpg" alt="Ilustrasi Slotted ALOHA">
                        <p>Transmisi data pada tiap node berdasarkan slot waktu tertentu</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Protokol Ethernet - CSMA</h3>
                <div>
                    <div>
                        <div>CSMA (Carrier Sense Multiple Access)</div>
                        <div>
                            <p><strong>"Dengarkan dulu sebelum bicara"</strong></p>
                            <ul>
                                <li>Sebelum kirim, node <em>mendengarkan</em> (sense) apakah channel sedang kosong.</li>
                                <li>Jika <strong>idle</strong>: kirim frame sepenuhnya.</li>
                                <li>Jika <strong>busy</strong>: tunda, tunggu sampai idle lalu kirim.</li>
                                <li>❌ Masih bisa collision! (karena <em>propagation delay</em> — sinyal butuh waktu
                                    merambat).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/csma_concept.jpg" alt="Ilustrasi Prinsip CSMA">
                        <p>Prinsip dasar 'Listen Before Talk' pada saluran jaringan</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Protokol Ethernet - CSMA/CD</h3>
                <div>
                    <div>
                        <div>CSMA/CD (Collision Detection)</div>
                        <div>
                            <p><strong>"Dengarkan sambil bicara, hentikan jika tabrakan"</strong></p>
                            <ul>
                                <li>Selama mengirim, node terus <em>mendengarkan</em> apakah ada sinyal lain
                                    (collision).</li>
                                <li>Jika collision terdeteksi: <strong>hentikan transmisi segera</strong>, kirim <em>jam
                                        signal</em> untuk memberi tahu semua node.</li>
                                <li>Tunggu waktu <strong>random (exponential backoff)</strong> lalu coba kirim lagi.
                                </li>
                                <li>✅ Mengurangi waktu buang — tidak perlu menunggu frame selesai sebelum tahu ada
                                    collision.</li>
                            </ul>
                            <div>
                                CSMA/CD digunakan di <strong>Ethernet kabel</strong>. Wi-Fi menggunakan CSMA/CA
                                (Collision Avoidance) karena tidak bisa mendeteksi collision saat kirim.
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/csmacd_concept.jpg" alt="Ilustrasi Prinsip CSMA/CD">
                        <p>Proses deteksi tabrakan data dan pengiriman Sinyal Jam</p>
                    </div>
                </div>
            </section>


            
            <section>
                <h3>Exponential Backoff — Mekanisme Coba Ulang</h3>
                <div>
                    <div>
                        <p>Setelah collision ke-n, node menunggu waktu acak yang dipilih dari rentang:</p>
                        <div>
                            Tunggu: <strong>K × 512 bit-time</strong><br><br>
                            K dipilih acak dari {0, 1, ..., 2ⁿ-1}<br><br>
                            Collision ke-1: K ∈ {0, 1}<br>
                            Collision ke-2: K ∈ {0, 1, 2, 3}<br>
                            Collision ke-3: K ∈ {0, ..., 7}<br>
                            ...<br>
                            Collision ke-10: K ∈ {0, ..., 1023}<br>
                            Collision ke-16: <span>Give up! ERROR</span>
                        </div>
                        <div>
                            💡 Semakin sering collision, semakin lama menunggu — ini <em>desentralisasi beban</em>
                            secara otomatis. Mirip antrian kasir: jika penuh, tunda sebentar, coba lagi nanti.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/exponential_backoff_concept.jpg" alt="Ilustrasi Exponential Backoff">
                        <p>Jendela rentang waktu tunggu menjadi dua kali lipat pasca tabrakan</p>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s6$qa$, $qa$jarkom-p4$qa$, $qa$5. MAC Address & ARP$qa$, $qa$<aside>Sekarang kita bahas bagaimana pengalamatan di lapisan link bekerja, dan bagaimana
                    IP address dipetakan ke MAC address.</aside>
            </section>

            
            <section>
                <h3>MAC Address: Identitas Fisik Hardware</h3>
                <div>
                    <div>
                        <p>Setiap antarmuka jaringan (NIC) memiliki <strong>MAC address 48-bit (6 byte)</strong> yang
                            unik secara global, ditulis dalam notasi heksadesimal:</p>
                        <div>
                            <span>1A:2F:BB:76:09:AD</span>
                        </div>
                        <ul>
                            <li><strong>3 byte pertama</strong> = OUI (Organizationally Unique Identifier) —
                                mengidentifikasi <em>produsen</em> NIC. Dialokasikan oleh IEEE.</li>
                            <li><strong>3 byte terakhir</strong> = Nomor unik yang ditetapkan produsen untuk tiap unit.
                            </li>
                            <li>Tersimpan di ROM pada chip NIC — biasanya tidak bisa diubah (namun bisa <em>spoofed</em>
                                via software).</li>
                        </ul>
                        <div>
                            🆚 <strong>MAC vs IP:</strong> MAC = alamat <em>fisik permanen</em> yang mengidentifikasi
                            hardware NIC. IP = alamat <em>logis dinamis</em> yang bergantung pada lokasi jaringan. MAC
                            seperti NIK, IP seperti alamat rumah.
                        </div>
                    </div>
                    <div>
                        <div>
                            <p>Struktur MAC
                                Address</p>
                            <div>
                                <span>1A:2F:BB</span>
                                <span>:</span>
                                <span>76:09:AD</span>
                            </div>
                            <div>
                                <div>OUI<br>Vendor ID
                                </div>
                                <div>Device<br>Serial
                                </div>
                            </div>
                            <hr>
                            <p>Contoh OUI terkenal:</p>
                            <ul>
                                <li>00:50:56 = VMware</li>
                                <li>A4:C3:F0 = Intel</li>
                                <li>DC:A6:32 = Raspberry Pi</li>
                            </ul>
                        </div>
                        <p>3 byte OUI + 3 byte serial = 48-bit MAC address</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>ARP: Address Resolution Protocol</h3>
                <div>
                    <div>
                        <p><strong>Masalah:</strong> Network layer punya IP address tujuan, tapi Data Link butuh MAC
                            address. Bagaimana caranya?</p>
                        <p>Jawaban: ARP (RFC 826)</p>
                        <ol>
                            <li><strong>ARP Table</strong>: Tiap node menyimpan tabel IP→MAC dengan TTL (biasanya 20
                                menit).</li>
                            <li><strong>ARP Query</strong>: Jika MAC tidak ada di tabel, node broadcast ARP request ke
                                seluruh LAN:<br>
                                <em>"Siapa yang punya IP 192.168.1.5? Beritahu MAC-mu!"</em>
                            </li>
                            <li><strong>ARP Reply</strong>: Node yang memiliki IP tersebut membalas secara unicast
                                dengan MAC address-nya.</li>
                            <li>Pengirim menyimpan pasangan IP→MAC ke tabel, lalu kirim frame.</li>
                        </ol>
                        <div>
                            ⚠️ ARP hanya bekerja di dalam <strong>satu subnet</strong> (satu LAN). Untuk kirim ke subnet
                            lain, frame dikirim ke <strong>gateway (router)</strong> menggunakan MAC address router.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week4/arp_concept.jpg" alt="Ilustrasi Skenario ARP">
                        <p>Proses resolusi ARP dalam satu LAN</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Pengiriman Antar Subnet via Router</h3>
                <div>
                    <p>Ketika host A (subnet 111.111.111.0) ingin kirim ke host B (subnet 222.222.222.0):</p>
                </div>
                <div>
                    <div>
                        <p>Langkah 1: A → Router</p>
                        <ul>
                            <li>A tahu IP tujuan = 222.222.222.1 (berbeda subnet).</li>
                            <li>A kirim frame ke <strong>MAC address Router</strong> (via ARP).</li>
                            <li>IP Dst dalam datagram = IP B (tetap).</li>
                            <li>MAC Dst dalam frame = MAC Router (berubah per hop).</li>
                        </ul>
                    </div>
                    <div>
                        <p>Langkah 2: Router Proses</p>
                        <ul>
                            <li>Router terima frame, ekstrak datagram.</li>
                            <li>Lihat IP Dst = 222.222.222.1.</li>
                            <li>Tentukan interface keluar lewat <strong>routing table</strong>.</li>
                            <li>ARP untuk mendapatkan <strong>MAC B</strong>.</li>
                        </ul>
                    </div>
                    <div>
                        <p>Langkah 3: Router → B</p>
                        <ul>
                            <li>Router buat frame baru dengan <strong>MAC Src = Router</strong>, <strong>MAC Dst = MAC
                                    B</strong>.</li>
                            <li>IP Dst dalam datagram tetap = IP B.</li>
                            <li>B terima frame, ambil datagram.</li>
                        </ul>
                    </div>
                </div>
                <div>
                    🔑 <strong>Kunci penting:</strong> IP address tujuan <em>tidak berubah</em> selama perjalanan. Tapi
                    MAC address <em>berubah di setiap hop</em>. IP = alamat global, MAC = alamat lokal per link.
                </div>
            </section>

            
            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s7$qa$, $qa$jarkom-p4$qa$, $qa$6. Ethernet$qa$, $qa$<aside>Ethernet adalah teknologi LAN yang dominan sejak 1970-an. Mari kita pelajari
                    evolusi dan karakteristiknya.</aside>
            </section>

            
            <section>
                <h3>Ethernet: Teknologi LAN Dominan</h3>
                <div>
                    <div>
                        <ul>
                            <li>Pertama kali dikembangkan oleh <strong>Xerox PARC</strong> tahun 1973 (Robert Metcalfe).
                            </li>
                            <li>Standar terbuka (IEEE 802.3) — satu chip bisa mendukung banyak kecepatan.</li>
                            <li>Evolusi kecepatan: <strong>10 Mbps → 100 Mbps → 1 Gbps → 10 Gbps → 400 Gbps</strong>.
                            </li>
                            <li>Bersifat <strong>connectionless</strong>: tidak ada handshaking sebelum kirim frame.
                            </li>
                            <li>Bersifat <strong>unreliable</strong>: penerima tidak mengirim ACK/NAK. Jika CRC error,
                                frame dibuang begitu saja — recovery diserahkan ke TCP di atasnya.</li>
                        </ul>
                        <div>
                            Alasan Ethernet bertahan selama 50+ tahun: <strong>sederhana, murah, dan berhasil mengikuti
                                perlombaan kecepatan</strong> tanpa mengubah antarmuka pemrogramannya.
                        </div>
                    </div>
                    <div>
                        <div>
                            <p>Evolusi Topologi
                                Ethernet</p>
                            <div>
                                <strong>Bus (1970–1990-an):</strong><br>
                                Semua host berbagi 1 kabel coaxial. Jika ada yang kirim, semua "dengar". Satu domain
                                collision besar.
                            </div>
                            <div>
                                <strong>Switched (1990-an–sekarang):</strong><br>
                                Host terhubung ke switch via kabel UTP dedicated. Tiap port = domain collision sendiri.
                                Tidak ada collision!
                            </div>
                        </div>
                        <p>Dari topologi bus ke switched</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Standar Ethernet (IEEE 802.3)</h3>
                <div>
                    <table>
                        <tr>
                            <th>Standar</th>
                            <th>Kecepatan</th>
                            <th>Medium</th>
                            <th>Jarak Maks</th>
                            <th>Keterangan</th>
                        </tr>
                        <tr>
                            <td>10BASE-T</td>
                            <td>10 Mbps</td>
                            <td>UTP Cat 3</td>
                            <td>100 m</td>
                            <td>Ethernet awal, sudah usang</td>
                        </tr>
                        <tr>
                            <td>100BASE-TX</td>
                            <td>100 Mbps</td>
                            <td>UTP Cat 5</td>
                            <td>100 m</td>
                            <td>Fast Ethernet, masih ada di gedung lama</td>
                        </tr>
                        <tr>
                            <td><strong>1000BASE-T</strong></td>
                            <td><strong>1 Gbps</strong></td>
                            <td>UTP Cat 5e/6</td>
                            <td>100 m</td>
                            <td>Gigabit Ethernet — standar umum saat ini</td>
                        </tr>
                        <tr>
                            <td>10GBASE-T</td>
                            <td>10 Gbps</td>
                            <td>UTP Cat 6a/7</td>
                            <td>100 m</td>
                            <td>Data Center, perkantoran high-end</td>
                        </tr>
                        <tr>
                            <td>1000BASE-LX</td>
                            <td>1 Gbps</td>
                            <td>Single-mode fiber</td>
                            <td>5–10 km</td>
                            <td>Backbone kampus / gedung</td>
                        </tr>
                        <tr>
                            <td>400GBASE</td>
                            <td>400 Gbps</td>
                            <td>Multi-fiber</td>
                            <td>~100 m</td>
                            <td>Hyperscale Data Center (cloud)</td>
                        </tr>
                    </table>
                </div>
                <div>
                    Notasi: <strong>Kecepatan BASE Medium</strong> — contoh "1000BASE-T" = 1000 Mbps (1 Gbps), baseband,
                    medium twisted pair.
                </div>
            </section>

            
            <section>$qa$, 7) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p4-s8$qa$, $qa$jarkom-p4$qa$, $qa$7. Ethernet Switch$qa$, $qa$<aside>Switch adalah perangkat layer 2 yang menggantikan hub. Perbedaan utamanya: switch
                    cerdas, hub bodoh.</aside>
            </section>

            
            <section>
                <h3>Ethernet Switch: Perangkat Layer 2</h3>
                <div>
                    <div>
                        <div>Cara Kerja Switch</div>
                        <div>
                            <ul>
                                <li>Switch adalah perangkat <strong>link-layer aktif</strong>: memeriksa MAC address
                                    tujuan frame, lalu meneruskannya hanya ke port yang tepat.</li>
                                <li><strong>Store-and-Forward:</strong> Terima frame lengkap, periksa CRC, baru
                                    teruskan.</li>
                                <li>Setiap port switch = domain collision tersendiri → tidak ada CSMA/CD yang diperlukan
                                    per port.</li>
                                <li>Mendukung <strong>transmisi simultan</strong>: A↔B dan C↔D bisa terjadi serentak
                                    tanpa interferensi.</li>
                                <li><strong>Transparent:</strong> Host tidak tahu ada switch — dari sudut pandang host,
                                    seperti terhubung langsung.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Switch vs Hub</div>
                        <div>
                            <table>
                                <tr>
                                    <th>Aspek</th>
                                    <th>Hub</th>
                                    <th>Switch</th>
                                </tr>
                                <tr>
                                    <td>Layer OSI</td>
                                    <td>Physical (L1)</td>
                                    <td>Data Link (L2)</td>
                                </tr>
                                <tr>
                                    <td>Kecerdasan</td>
                                    <td>Broadcast semua port</td>
                                    <td>Forward berdasarkan MAC</td>
                                </tr>
                                <tr>
                                    <td>Collision Domain</td>
                                    <td>Satu besar</td>
                                    <td>Per port</td>
                                </tr>
                                <tr>
                                    <td>Simultaneous</td>
                                    <td>Tidak</td>
                                    <td>Ya</td>
                                </tr>
                                <tr>
                                    <td>Full-Duplex</td>
                                    <td>Tidak</td>
                                    <td>Ya</td>
                                </tr>
                                <tr>
                                    <td>Harga</td>
                                    <td>Murah</td>
                                    <td>Lebih mahal</td>
                                </tr>
                            </table>
                        </div>
                        <div>
                            ✅ Hub sudah hampir tidak digunakan. Switch adalah standar de-facto di semua jaringan LAN
                            modern.
                        </div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Switch: Self-Learning &amp; Forwarding</h3>
                <div>
                    <div>
                        <p>Switch belajar secara otomatis — <strong>tidak perlu dikonfigurasi manual</strong>:</p>
                        <ol>
                            <li><strong>Catat MAC sumber:</strong> Setiap frame yang diterima, switch mencatat MAC
                                address pengirim dan port masuknya ke <em>forwarding table</em> (SAT).</li>
                            <li><strong>Lookup MAC tujuan:</strong>
                                <ul>
                                    <li>Jika MAC tujuan <em>ada</em> di tabel → <strong>forward</strong> hanya ke port
                                        tersebut.</li>
                                    <li>Jika MAC tujuan <em>tidak ada</em> → <strong>flood</strong> ke semua port
                                        kecuali port masuk.</li>
                                    <li>Jika tujuan = pengirim (same segment) → <strong>filter</strong> (buang, tidak
                                        perlu diteruskan).</li>
                                </ul>
                            </li>
                            <li><strong>TTL entry:</strong> Setiap entri punya TTL. Jika tidak ada aktivitas, entri
                                dihapus.</li>
                        </ol>
                        <div>
                            💡 Inilah mengapa switch "plug-and-play" — cukup colokkan kabel, switch akan belajar sendiri
                            dalam hitungan detik.
                        </div>
                    </div>
                    <div>
                        <div>
                            <p>Switch Forwarding
                                Table (Contoh)</p>
                            <table>
                                <tr>
                                    <th>MAC Address</th>
                                    <th>Interface</th>
                                    <th>TTL</th>
                                </tr>
                                <tr>
                                    <td>1A:2F:BB:76:09:AD</td>
                                    <td>Port 1</td>
                                    <td>60s</td>
                                </tr>
                                <tr>
                                    <td>58:23:D7:FA:20:B0</td>
                                    <td>Port 3</td>
                                    <td>45s</td>
                                </tr>
                                <tr>
                                    <td>0C:C4:7A:12:34:56</td>
                                    <td>Port 5</td>
                                    <td>30s</td>
                                </tr>
                                <tr>
                                    <td><em>AA:BB:CC:DD:EE:FF</em></td>
                                    <td><em>???</em></td>
                                    <td><em>Belum ada → Flood</em></td>
                                </tr>
                            </table>
                            <div>
                                Frame dari A ke B:<br>
                                • Src A → simpan ke Port 1<br>
                                • Dst B ada di Port 3 → forward ke Port 3 saja ✅
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Menghubungkan Banyak Switch</h3>
                <div>
                    <div>
                        <p>Switch dapat dihubungkan satu sama lain untuk membentuk jaringan LAN yang lebih besar:</p>
                        <ul>
                            <li>Self-learning tetap bekerja — tabel di setiap switch dibangun secara independen.</li>
                            <li>Jika S1 menerima frame ke tujuan yang tidak dikenalnya, S1 akan <em>flood</em> ke semua
                                port termasuk uplink ke S2, S3, dst.</li>
                            <li>Tabel setiap switch akan terisi seiring traffic berjalan.</li>
                        </ul>
                        <div>
                            🏫 Di jaringan kampus modern, arsitektur 3-tier umum digunakan: <strong>Access →
                                Distribution → Core</strong> switch. Access terhubung ke end-device, Core menghubungkan
                            antar gedung dengan kecepatan sangat tinggi (10–100 Gbps).
                        </div>
                        <div>
                            ⚠️ Masalah loop! Tanpa mekanisme tambahan, flood bisa menyebabkan storm broadcast yang tak
                            terhenti. Solusinya: <strong>Spanning Tree Protocol (STP/RSTP)</strong> — memblokir port
                            tertentu agar tidak terbentuk loop.
                        </div>
                    </div>
                    <div>
                        <div>
                            <p>Arsitektur 3-Tier Campus LAN</p>
                            <div>
                                Core Switch<br><em>(10–100 Gbps)</em></div>
                            <div>
                                <div>
                                    Distrib. SW</div>
                                <div>
                                    Distrib. SW</div>
                            </div>
                            <div>
                                <div>
                                    Access<br>SW</div>
                                <div>
                                    Access<br>SW</div>
                                <div>
                                    Access<br>SW</div>
                                <div>
                                    Access<br>SW</div>
                            </div>
                            <div>PC, Laptop, Printer, IP Phone, AP
                            </div>
                        </div>
                        <p>Hierarki switch di jaringan kampus</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Switch vs Router: Apa Bedanya?</h3>
                <div>
                    <table>
                        <tr>
                            <th>Aspek</th>
                            <th>Switch (L2)</th>
                            <th>Router (L3)</th>
                        </tr>
                        <tr>
                            <td>Layer OSI</td>
                            <td>Data Link (L2)</td>
                            <td>Network (L3)</td>
                        </tr>
                        <tr>
                            <td>Alamat yang digunakan</td>
                            <td>MAC address</td>
                            <td>IP address</td>
                        </tr>
                        <tr>
                            <td>Tabel yang dibangun</td>
                            <td>Forwarding table (MAC → Port)</td>
                            <td>Routing table (IP network → Interface)</td>
                        </tr>
                        <tr>
                            <td>Cara belajar</td>
                            <td>Self-learning (otomatis)</td>
                            <td>Routing protocol (RIP, OSPF, BGP) atau manual</td>
                        </tr>
                        <tr>
                            <td>Broadcast domain</td>
                            <td>Tidak memisahkan (flood broadcast)</td>
                            <td>Memisahkan (broadcast tidak dilewatkan)</td>
                        </tr>
                        <tr>
                            <td>Koneksi antar jaringan</td>
                            <td>Tidak bisa (hanya dalam satu subnet)</td>
                            <td>Ya (bisa hubungkan banyak subnet)</td>
                        </tr>
                        <tr>
                            <td>Plug-and-play</td>
                            <td>Ya — zero config</td>
                            <td>Tidak — perlu konfigurasi IP, routing</td>
                        </tr>
                    </table>
                </div>
                <div>
                    <div>
                        🔌 <strong>Gunakan Switch</strong> untuk menghubungkan perangkat dalam satu subnet (LAN) yang
                        sama — lebih murah dan plug-and-play.
                    </div>
                    <div>
                        🌐 <strong>Gunakan Router</strong> untuk menghubungkan subnet yang berbeda atau ke internet —
                        butuh konfigurasi tapi lebih powerful.
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Rangkuman Pertemuan 4</h3>
                <div>
                    <div>
                        <p>Lapisan Data Link &amp; Error Handling</p>
                        <ul>
                            <li>Data Link: framing, link access, flow control, error detection.</li>
                            <li>Frame Ethernet: Preamble | MAC Dst | MAC Src | Type | Data | CRC.</li>
                            <li>Deteksi error: <strong>Parity</strong> (sederhana), <strong>Checksum</strong>
                                (UDP/TCP/IP), <strong>CRC</strong> (Ethernet — paling powerful).</li>
                            <li>Implementasi di <strong>NIC</strong> — ada di setiap host &amp; perangkat jaringan.</li>
                        </ul>
                    </div>
                    <div>
                        <p>MAC, ARP, Ethernet &amp; Switch</p>
                        <ul>
                            <li>MAC address = 48-bit, unik per NIC, tidak berubah per hop.</li>
                            <li>ARP: memetakan IP → MAC dalam satu subnet (broadcast query, unicast reply).</li>
                            <li>Multiple Access: Channel Partition (TDMA/FDMA) · Random (CSMA/CD) · Taking Turns.</li>
                            <li>Ethernet: connectionless, unreliable, CSMA/CD, CRC-32.</li>
                            <li>Switch: self-learning forwarding table, per-port collision domain, simultan.</li>
                            <li>Switch (L2/MAC) vs Router (L3/IP) — berbeda fungsi dan skala.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <div>
                    <h3>Tugas Pertemuan 4</h3>
                    
                    <p>Dikerjakan analitik, ditulis tangan di
                        kertas folio bergaris, di-scan dengan jelas, lalu kirim format PDF ke e-learning.</p>

                    <div>
                        <p><span>1.</span> Di sebuah laboratorium komputer terdapat 30 PC yang semuanya
                            terhubung ke <strong>satu hub</strong> 100 Mbps tipe lama. Mahasiswa mengeluhkan jaringan
                            sangat lambat terutama saat banyak yang menggunakan serentak. <strong>Jelaskan secara teknis
                                berdasarkan logika CSMA/CD</strong> mengapa hal ini terjadi (kaitkan dengan
                            <em>collision domain</em> dan efisiensi <em>bandwidth</em>). <strong>Rancanglah</strong>
                            solusi <em>upgrade</em> menggunakan <em>switch</em> dan jelaskan peningkatan
                            <em>bandwidth</em> efektif per PC.
                        </p>
                    </div>

                    <div>
                        <p><span>2.</span> Seorang administrator mendeteksi anomali di jaringan LAN.
                            Ternyata terjadi serangan <strong>ARP Spoofing</strong> — penyerang mengirimkan <em>ARP
                                Reply</em> palsu secara terus-menerus. <strong>Uraikan tahap demi tahap</strong>
                            bagaimana serangan ini bekerja memanipulasi pemetaan tabel IP ke MAC di
                            <strong>Node</strong> korban, dan
                            <strong>analisislah</strong> celah kelemahan pada protokol ARP yang dimanfaatkan oleh
                            penyerang (berdasarkan cara kerjanya di materi).
                        </p>
                    </div>

                    <div>
                        <p><span>3.</span> Sebuah <em>frame</em> Ethernet dari <em>Server</em> diterima oleh
                            <em>NIC (Network Interface Card)</em> PC Anda, namun hasil perhitungan CRC (Cyclic
                            Redundancy Check) di sisi penerima tidak cocok dengan nilai CRC di <em>trailer frame</em>.
                            <strong>Analisislah skenario ini</strong>: (a) Tindakan pasti apa yang akan diambil oleh NIC
                            terhadap <em>frame</em> tersebut? (b) Karena <em>Ethernet</em> bersifat <em>unreliable</em>,
                            lapisan manakah yang bertanggung jawab meminta data dikirim ulang? Jelaskan alasannya.
                        </p>
                    </div>

                    <div>
                        <div><i></i> Tulis tangan asli</div>
                        <div><i></i> No AI Allowed</div>
                        <div><i></i> Scan PDF ke E-learning</div>
                        <div><i></i> Deadline: H-1 PTM 5</div>
                    </div>
                </div>
            </section>

            <section>$qa$, 8) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-c1$qa$, $qa$jarkom-p4$qa$, $qa$checkpoint$qa$, $qa$Alamat fisik yang unik pada kartu jaringan (NIC) disebut...$qa$, $qa$["IP address", "MAC address", "Port", "SSID"]$qa$::jsonb, 1, $qa$MAC address adalah alamat 48-bit bawaan NIC di lapisan Data Link.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-c2$qa$, $qa$jarkom-p4$qa$, $qa$checkpoint$qa$, $qa$CRC pada trailer frame Ethernet berfungsi untuk...$qa$, $qa$["Mengenkripsi data", "Mengompresi data", "Mendeteksi error pada frame", "Menentukan rute"]$qa$::jsonb, 2, $qa$CRC dipakai penerima untuk memeriksa frame rusak atau tidak.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-c3$qa$, $qa$jarkom-p4$qa$, $qa$checkpoint$qa$, $qa$Perangkat yang bekerja di lapisan Data Link dan meneruskan frame berdasarkan tabel MAC adalah...$qa$, $qa$["Hub", "Switch", "Repeater", "Modem"]$qa$::jsonb, 1, $qa$Switch belajar tabel MAC dan meneruskan frame ke port tujuan saja.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-b1$qa$, $qa$jarkom-p4$qa$, $qa$battle$qa$, $qa$NIC menerima frame Ethernet tetapi perhitungan CRC tidak cocok dengan trailer. Tindakan yang TEPAT adalah...$qa$, $qa$["NIC meminta pengiriman ulang frame tersebut", "NIC membuang frame; pengiriman ulang menjadi tanggung jawab TCP", "NIC memperbaiki bit yang rusak memakai CRC", "NIC meneruskan frame ke aplikasi apa adanya"]$qa$::jsonb, 1, $qa$Ethernet bersifat unreliable: CRC hanya mendeteksi, frame rusak dibuang, reliabilitas diserahkan ke layer transport (TCP).$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-b2$qa$, $qa$jarkom-p4$qa$, $qa$battle$qa$, $qa$Dalam CSMA/CD, ketika sebuah node mendeteksi collision saat mengirim, ia akan...$qa$, $qa$["Melanjutkan pengiriman sampai frame selesai", "Berhenti segera, mengirim jam signal, lalu menunggu waktu acak (backoff)", "Menunggu token dari node master", "Meminta slot waktu ke access point"]$qa$::jsonb, 1, $qa$CD = collision detection: hentikan transmisi, beri tahu semua node lewat jam signal, coba lagi setelah backoff eksponensial.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-b3$qa$, $qa$jarkom-p4$qa$, $qa$battle$qa$, $qa$Host A ingin mengirim frame ke 192.168.1.5 di LAN yang sama tetapi belum tahu MAC-nya. Langkah yang benar...$qa$, $qa$["Mengirim unicast langsung ke IP tujuan", "Broadcast ARP request menanyakan pemilik IP tersebut", "Meminta MAC ke router tetangga", "Menebak MAC dari OUI IP address"]$qa$::jsonb, 1, $qa$ARP query di-broadcast ke seluruh LAN; pemilik IP membalas unicast dengan MAC-nya, lalu disimpan di ARP table.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-b4$qa$, $qa$jarkom-p4$qa$, $qa$battle$qa$, $qa$30 PC dihubungkan ke satu hub 100 Mbps dan jaringan lambat saat ramai. Upgrade ke switch membantu karena...$qa$, $qa$["Switch memperbesar bandwidth menjadi 1 Gbps otomatis", "Tiap port switch adalah collision domain tersendiri sehingga tidak ada tabrakan", "Switch menghilangkan kebutuhan MAC address", "Switch bekerja di layer 3 seperti router"]$qa$::jsonb, 1, $qa$Hub = satu collision domain besar berbasis broadcast; switch meneruskan frame hanya ke port tujuan berdasar MAC.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p4-b5$qa$, $qa$jarkom-p4$qa$, $qa$battle$qa$, $qa$Paket dikirim dari Jakarta ke Surabaya melewati 5 router. Manakah yang benar?$qa$, $qa$["IP tujuan berubah di setiap router", "MAC address tujuan sama dari awal sampai akhir", "IP tujuan tetap, MAC address tujuan berubah di setiap hop", "Baik IP maupun MAC berubah di setiap hop"]$qa$::jsonb, 2, $qa$IP adalah alamat global end-to-end yang tidak berubah; MAC hanya bermakna per-link sehingga ditulis ulang tiap hop.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
