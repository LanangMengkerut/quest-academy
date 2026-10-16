insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p6$qa$, $qa$jarkom$qa$, $qa$IP Addressing & Subnetting$qa$, $qa$<h3>Forwarding vs Routing</h3>
<ul>
<li><strong>Forwarding (data plane):</strong> aksi lokal & cepat — pindahkan paket dari input link ke output link yang tepat (seperti baca rambu di simpang tol).</li>
<li><strong>Routing (control plane):</strong> aksi global — susun peta jaringan/tabel routing via protokol seperti OSPF & BGP (seperti rencanakan rute di peta).</li>
</ul>
<h3>Anatomi IPv4</h3>
<p>32-bit, terbagi jadi <strong>network portion</strong> (nama jalan) dan <strong>host portion</strong> (nomor rumah); batasnya ditentukan <strong>subnet mask</strong>/prefix.</p>
<table>
<tr><th>Kelas</th><th>Range</th><th>Default</th><th>Private</th></tr>
<tr><td>A</td><td>1.0.0.0 - 126.255.255.255</td><td>/8</td><td>10.0.0.0/8</td></tr>
<tr><td>B</td><td>128.0.0.0 - 191.255.255.255</td><td>/16</td><td>172.16.0.0/12</td></tr>
<tr><td>C</td><td>192.0.0.0 - 223.255.255.255</td><td>/24</td><td>192.168.0.0/16</td></tr>
<tr><td>D</td><td>224.0.0.0 - 239.255.255.255</td><td>multicast</td><td>-</td></tr>
<tr><td>E</td><td>240.0.0.0 - 255.255.255.255</td><td>eksperimen</td><td>-</td></tr>
</table>
<p>Private IP butuh <strong>NAT</strong> di router agar bisa akses internet.</p>
<h3>Tipe Komunikasi</h3>
<ul>
<li><strong>Unicast:</strong> satu ke satu (paling umum). <strong>Broadcast:</strong> satu ke semua di jaringan (255.255.255.255; router tidak meneruskan). <strong>Multicast:</strong> satu ke grup pelanggan (kelas D, hemat bandwidth).</li>
</ul>
<h3>Subnetting</h3>
<p>Meminjam bit host untuk memecah network besar jadi subnet-subnet kecil: memperkecil broadcast domain & memudahkan keamanan.</p>
<ul>
<li>Notasi CIDR: /26 berarti 26 bit network, 6 bit host.</li>
<li><strong>Usable IP = 2^(bit host) - 2</strong> (kurangi network ID & broadcast). Contoh /26 menjadi 64 - 2 = 62.</li>
<li>Cari blok dengan kelipatan: /26 berarti kelipatan 64 (0, 64, 128, 192).</li>
</ul>
<h3>VLSM</h3>
<p>FLSM memotong sama besar (boros). <strong>VLSM</strong> memotong tak rata sesuai kebutuhan. <strong>Aturan emas:</strong> urutkan kebutuhan dari terbesar, pilih prefix terkecil yang muat. Contoh: 100 host menjadi /25, 50 host menjadi /26, link P2P 2 host menjadi /30.</p>
<h3>IPv6</h3>
<ul>
<li>128-bit heksadesimal, 8 hextet (contoh 2001:0db8:...). Sederhanakan: buang leading zero; <strong>::</strong> untuk blok nol berurutan (sekali saja).</li>
<li>Lahir karena IPv4 habis (4,3 miliar) & ledakan IoT. Kapasitas 340 undecillion.</li>
<li>Tanpa broadcast (diganti anycast), <strong>SLAAC</strong> (autoconfigurasi tanpa DHCP), header tetap 40 byte.</li>
<li>Subnet standar <strong>/64</strong> per LAN; hemat-hematan tak lagi relevan; P2P pakai /127.</li>
</ul>
<h3>DHCP</h3>
<ul>
<li>Otomatis memberi IP + subnet mask + gateway + DNS (plug-and-play) via UDP (server port 67, client 68).</li>
<li><strong>D.O.R.A:</strong> Discover (broadcast, klien belum punya IP) lalu Offer lalu Request lalu ACK.</li>
<li>Gagal DHCP menjadi <strong>APIPA 169.254.0.0/16</strong>: tanpa gateway, hanya bisa komunikasi lokal. Tanda teknisi: 169.254.x.x berarti layer 1/2 bagus, layanan DHCP rusak.</li>
</ul>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan06.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 6) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s1$qa$, $qa$jarkom-p6$qa$, $qa$IP Addressing & Subnetting$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>

            
            <section>
                <div>
                    
                    <h3>Pertemuan 6 (Network Layer)</h3>
                </div>
                <p>Referensi Utama: Kurose &amp; Ross — <em>Computer Networking (8th Ed)</em></p>
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
                    <div>
                        <p>Bagian 1: Konsep Network Layer</p>
                        <ul>
                            <li>Forwarding vs Routing</li>
                            <li>Anatomi IPv4 & Kelas IP (A, B, C, D, E)</li>
                            <li>Tipe Komunikasi (Unicast, Broadcast, Multicast)</li>
                        </ul>
                        <p>Bagian 2: Subnetting & VLSM</p>
                        <ul>
                            <li>Konsep Dasar Subnetting & Tabel Subnet</li>
                            <li>VLSM (Variable Length Subnet Mask)</li>
                            <li>Studi Kasus Perhitungan Blok & VLSM</li>
                        </ul>
                    </div>
                </div>
            </section>

            <section>
                <h3>Outline Materi</h3>
                <div>
                    <div>
                        <p>Bagian 3: IPv6</p>
                        <ul>
                            <li>Kelemahan IPv4 & Solusi IPv6</li>
                            <li>Format Hexadesimal & Konversi</li>
                            <li>Implementasi, Subnetting & VLSM di IPv6</li>
                        </ul>
                    </div>
                    <div>
                        <p>Bagian 4: DHCP</p>
                        <ul>
                            <li>Konfigurasi IP Dinamis</li>
                            <li>Proses D.O.R.A Secara Detail</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s2$qa$, $qa$jarkom-p6$qa$, $qa$1. Peran Network Layer$qa$, $qa$</section>

            <section>
                <h3>Fungsi Utama Lapisan Network</h3>
                <div>
                    <p>Tanggung jawab utama: Mengirim paket dari <strong>host asal</strong> ke <strong>host
                            tujuan</strong> melintasi jaringan global.</p>
                    <p>Dua Fungsi Kunci (Kurose):</p>
                    <ul>
                        <li><strong>Forwarding (Data Plane):</strong> Aksi lokal (cepat/hardware).
                            Memindahkan paket dari pintu masuk (input link) ke pintu keluar (output link) router yang
                            sesuai.</li>
                        <li><strong>Routing (Control Plane):</strong> Aksi global (algoritma).
                            Menentukan rute atau jalur perjalanan paket dari hulu ke hilir melewati banyak router.</li>
                    </ul>
                    <aside>
                        Lapisan Network bertanggung jawab penuh agar paket bisa sampai dari ujung ke ujung.
                        Jelaskan bahwa Forwarding itu proses pemindahan fisik di dalam 1 perangkat router saja,
                        sedangkan Routing adalah proses pertukaran informasi antar router di seluruh dunia untuk
                        membangun peta jalan.
                    </aside>
                </div>
            </section>

            <section>
                <h3>Analogi: Forwarding vs Routing</h3>
                <div>
                    <div>
                        <p>Routing (Control Plane)</p>
                        <div><i></i></div>
                        <p>Seperti Anda merencanakan rute perjalanan dari Jakarta ke Bandung
                            menggunakan Google Maps sebelum berangkat.</p>
                    </div>
                    <div>
                        <p>Forwarding (Data Plane)</p>
                        <div><i></i></div>
                        <p>Seperti Anda sampai di simpang susun jalan tol, membaca rambu
                            petunjuk jalan, lalu memutar setir ke pintu keluar tol yang tepat.</p>
                    </div>
                </div>
            </section>

            <section>
                <h3>Routing (Control Plane) dalam Konteks IP</h3>
                <div>
                    <div>
                        <p><strong>Bagaimana Routing bekerja dengan IP Address?</strong></p>
                        <ul>
                            <li>Router bertukar informasi via protokol (OSPF, BGP) untuk menyusun "Peta
                                Jaringan" (Tabel Routing).</li>
                            <li>Router <strong>TIDAK</strong> menghafal setiap IP komputer di dunia,
                                melainkan hanya <strong>Network ID (Subnet)</strong>.</li>
                            <li>Misal: "Menuju kampus ITERA (Network <code>103.x.x.0</code>), lewat
                                jalur A". Detail IP perangkat (Pengelompokan IP) diatur oleh <strong>Subnet
                                    Mask</strong>.</li>
                            <li>Inilah fungsi <strong>Subnetting</strong>: meringkas rute (<em>Route
                                    Summarization</em>) agar tabel routing tidak meledak.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/routing_control_plane.jpg" alt="Ilustrasi Control Plane Routing">
                    </div>
                </div>
            </section>

            <section>
                <h3>Forwarding (Data Plane) dalam Konteks IP</h3>
                <div>
                    <div>
                        <p><strong>Bagaimana Forwarding bekerja secara lokal?</strong></p>
                        <ol>
                            <li>Paket tiba di <strong>port masuk</strong> (input interface) router.
                            </li>
                            <li>Router membaca <strong>Destination IP Address</strong> di header paket.
                            </li>
                            <li>Router menghitung <strong>Network ID</strong> dari IP tujuan tersebut.
                            </li>
                            <li>Mencocokkan Network ID dengan <strong>Forwarding Table</strong> (tabel
                                lokal).</li>
                            <li>Paket diteruskan ke <strong>port keluar</strong> (output interface)
                                yang sesuai. Sangat cepat (<em>hardware-based</em>)!</li>
                        </ol>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/forwarding_data_plane.jpg" alt="Ilustrasi Data Plane Forwarding">
                    </div>
                </div>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s3$qa$, $qa$jarkom-p6$qa$, $qa$2. Anatomi IP Address (IPv4)$qa$, $qa$</section>

            <section>
                <h3>Apa itu IP Address?</h3>
                <div>
                    <div>
                        <p>Pengenal numerik 32-bit (IPv4) yang dipasangkan pada <strong>antarmuka (interface)</strong>
                            host/router.</p>
                        <ul>
                            <li>Satu perangkat bisa memiliki <strong>banyak IP address</strong> (misal:
                                IP WiFi berbeda dengan IP kabel LAN).</li>
                            <li>Router selalu memiliki >1 IP address, karena bertugas menghubungkan
                                banyak subnet sekaligus.</li>
                        </ul>
                        <div>
                            IP address <strong>BUKAN</strong> milik fisik perangkat, melainkan milik koneksi
                            antarmukanya. Jika laptop pindah dari WiFi kampus ke WiFi kosan, IP-nya pasti berubah!
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/apa_itu_ip.jpg" alt="Ilustrasi Apa itu IP Address">
                    </div>
                </div>
            </section>

            <section>
                <h3>Porsi Network dan Host</h3>
                <div>
                    <div>
                        <p>Setiap IP address (IPv4) secara logis terbagi menjadi 2 bagian:</p>
                        <ul>
                            <li><strong>Network Portion (Net ID):</strong> Mengidentifikasi di jaringan (subnet) mana
                                komputer itu berada. Seperti nama "Jalan" pada alamat rumah.</li>
                            <li><strong>Host Portion (Host ID):</strong> Mengidentifikasi perangkat spesifik di dalam
                                jaringan tersebut. Seperti "Nomor Rumah".</li>
                        </ul>
                        <p>Bagaimana komputer tahu batas pemisahnya? Disitulah peran
                            <strong>Subnet Mask</strong>! (Sering juga ditulis dengan tanda <em>slash</em> atau
                            <strong>prefix</strong>, misal: <code>/24</code> yang akan kita bahas nanti).
                        </p>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/ip_anatomy.png" alt="Anatomi IPv4">
                    </div>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s4$qa$, $qa$jarkom-p6$qa$, $qa$3. Kelas IP Address & Tipe Komunikasi IPv4$qa$, $qa$</section>

            <section>
                <h3>Kelas IP Address (Classful) & Private IP</h3>
                <div>
                    <p>Pada awalnya, IP Address dibagi secara kaku ke dalam 5 kelas. Selain itu, ada rentang IP
                        <strong>Private</strong> yang tidak bisa di-routing di internet global (hanya untuk LAN).
                    </p>
                    <table>
                        <tr>
                            <th>Kelas</th>
                            <th>Range IP Global</th>
                            <th>Subnet Mask (Default)</th>
                            <th>Range Private IP Address</th>
                        </tr>
                        <tr>
                            <td><strong>A</strong> (Skala Besar)</td>
                            <td>1.0.0.0 — 126.255.255.255</td>
                            <td>/8 (255.0.0.0)</td>
                            <td><strong>10.0.0.0 — 10.255.255.255</strong></td>
                        </tr>
                        <tr>
                            <td><strong>B</strong> (Skala Menengah)</td>
                            <td>128.0.0.0 — 191.255.255.255</td>
                            <td>/16 (255.255.0.0)</td>
                            <td><strong>172.16.0.0 — 172.31.255.255</strong></td>
                        </tr>
                        <tr>
                            <td><strong>C</strong> (Skala Kecil)</td>
                            <td>192.0.0.0 — 223.255.255.255</td>
                            <td>/24 (255.255.255.0)</td>
                            <td><strong>192.168.0.0 — 192.168.255.255</strong></td>
                        </tr>
                        <tr>
                            <td><strong>D</strong> (Multicast)</td>
                            <td>224.0.0.0 — 239.255.255.255</td>
                            <td><em>Tidak didefinisikan (N/A)</em></td>
                            <td><em>(Semua digunakan untuk Multicast)</em></td>
                        </tr>
                        <tr>
                            <td><strong>E</strong> (Eksperimental)</td>
                            <td>240.0.0.0 — 255.255.255.255</td>
                            <td><em>Tidak didefinisikan (N/A)</em></td>
                            <td><em>(Untuk riset & eksperimen)</em></td>
                        </tr>
                    </table>
                    <div>
                        Untuk komputer dengan Private IP bisa mengakses internet, ia harus ditranslasikan ke Public IP
                        oleh Router menggunakan <strong>NAT (Network Address Translation)</strong>.
                    </div>
                </div>
            </section>

            <section>
                <h3>Tipe Komunikasi: Unicast</h3>
                <div>
                    <div>
                        <p><strong>Unicast (Satu-ke-Satu):</strong></p>
                        <p>Mengirim paket dari satu IP pengirim ke satu IP tujuan spesifik.</p>
                        <ul>
                            <li>Metode komunikasi paling umum di jaringan.</li>
                            <li>Tujuan alamatnya pasti dan hanya akan di-proses oleh satu perangkat penerima.</li>
                            <li><strong>Contoh:</strong> Laptop A (192.168.1.10) mengirim file ke Laptop B
                                (192.168.1.25).</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/unicast.png" alt="Ilustrasi Unicast">
                    </div>
                </div>
            </section>

            <section>
                <h3>Tipe Komunikasi: Broadcast</h3>
                <div>
                    <div>
                        <p><strong>Broadcast (Satu-ke-Semua):</strong></p>
                        <p>Mengirim paket dari satu pengirim ke <strong>seluruh</strong> perangkat di jaringan yang
                            sama.</p>
                        <ul>
                            <li><strong>Limited Broadcast:</strong> Menggunakan alamat tujuan
                                <code>255.255.255.255</code>. Router akan menolak meneruskan paket ini ke luar jaringan
                                lokal.
                            </li>
                            <li><strong>Directed Broadcast:</strong> Menggunakan IP tujuan di mana seluruh bit Host
                                bernilai 1 (Contoh: <code>192.168.1.255</code>). Mengirim ke semua host pada subnet
                                spesifik.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/broadcast.png" alt="Ilustrasi Broadcast">
                    </div>
                </div>
            </section>

            <section>
                <h3>Tipe Komunikasi: Multicast</h3>
                <div>
                    <div>
                        <p><strong>Multicast (Satu-ke-Banyak-Grup):</strong></p>
                        <p>Mengirim paket dari satu pengirim ke <strong>sekelompok</strong> host tertentu yang
                            berlangganan (subscribe) pada grup tersebut.</p>
                        <ul>
                            <li>Sangat efisien untuk menghemat bandwidth (contoh: Live Streaming Video atau komunikasi
                                Routing Protocol).</li>
                            <li>Menggunakan alokasi IP Address <strong>Kelas D</strong> (Range 224.0.0.0 s/d
                                239.255.255.255).</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/multicast.png" alt="Ilustrasi Multicast">
                    </div>
                </div>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s5$qa$, $qa$jarkom-p6$qa$, $qa$4. Subnetting & CIDR$qa$, $qa$</section>

            <section>
                <h3>Refreshment: Konversi Biner ↔ Desimal (IPv4)</h3>
                <div>
                    <p>Untuk memahami subnetting, kita <strong>wajib</strong> menguasai konversi biner ke desimal (dan
                        sebaliknya) per oktet. IP V4 terdiri dari 4 oktet (32 bit).</p>
                    <p>Contoh: Konversi IP <code>172.16.50.126</code> ke Biner</p>
                    <div>
                        Tabel Bantuan (Nilai Bit): 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 <br><br>
                        <strong>Oktet 1 (172):</strong> 128 + 32 + 8 + 4 = <strong>10101100</strong><br>
                        <strong>Oktet 2 (16):</strong> 16 = <strong>00010000</strong><br>
                        <strong>Oktet 3 (50):</strong> 32 + 16 + 2 = <strong>00110010</strong><br>
                        <strong>Oktet 4 (126):</strong> 64 + 32 + 16 + 8 + 4 + 2 = <strong>01111110</strong>
                    </div>
                    <p>Hasil Biner:
                        <code>10101100.00010000.00110010.01111110</code>
                    </p>
                    <div>
                        <strong>Tips:</strong> Jika bit paling kanan (angka 1) adalah 0, maka desimalnya pasti GENAP.
                        Jika 1, pasti GANJIL! (126 adalah genap, bit terakhirnya 0).
                    </div>
                </div>
            </section>

            <section>
                <h3>Classful vs Classless (CIDR)</h3>
                <div>
                    <p><strong>Classful Addressing (Jadul):</strong></p>
                    <ul>
                        <li>IP dibagi kaku menjadi Kelas A (prefix /8), B (prefix /16), dan C (prefix /24).
                            <br><em>(Sebagai catatan: IPv4 memiliki 32 bit.
                                Prefix /16 berarti sisa 16 bit untuk host. Total IP = 2<sup>16</sup> &asymp; 65 ribu
                                IP)</em>
                        </li>
                        <li><strong>Kekurangan:</strong> Sangat boros! Perusahaan yang butuh 500 IP harus mengambil
                            Kelas B (kapasitas 65 ribu host). Sisa 64.500 IP terbuang percuma.</li>
                    </ul>
                    <p>CIDR - Classless Inter-Domain Routing (Modern):</p>
                    <ul>
                        <li>Membuang batas kelas! Prefix bisa sepanjang apapun secara fleksibel.</li>
                        <li>Format notasi <strong>Slash ( / )</strong>: <code>192.168.1.50/26</code>.</li>
                        <li>Angka <code>/26</code> artinya 26 bit pertama adalah porsi Network, sisanya (32-26 = 6 bit)
                            adalah porsi Host.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Apa itu Subnetting?</h3>
                <div>
                    <div>
                        <p><strong>Subnetting</strong> adalah proses meminjam bit dari porsi Host untuk memecah
                            sekumpulan blok IP besar (sebuah network utama) menjadi beberapa kelompok jaringan kecil
                            (Sub-network).</p>
                        <p>Mengapa kita butuh subnetting?</p>
                        <ul>
                            <li>Mengurangi ukuran broadcast domain (mengurangi traffic broadcast yang tidak perlu).</li>
                            <li>Meningkatkan performa jaringan.</li>
                            <li>Memudahkan manajemen dan penerapan kebijakan keamanan (Firewall antar divisi).</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/subnetting.png" alt="Analogi Subnetting seperti memotong Pizza">
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Tabel Subnetting IPv4 (/8 s.d /32)</h3>
                <div>
                    <p>Tabel referensi lengkap CIDR dengan nilai biner (Bit Network: <span>Biru</span>, Bit Host: <span>Oranye</span>).</p>
                </div>
                <div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th>CIDR</th>
                                <th>Subnet Mask (Biner)</th>
                                <th>Desimal</th>
                                <th>Usable IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>/8</td>
                                <td><span>11111111.</span><span>00000000.00000000.00000000</span></td>
                                <td>255.0.0.0</td>
                                <td>16,777,214</td>
                            </tr>
                            <tr>
                                <td>/9</td>
                                <td><span>11111111.1</span><span>0000000.00000000.00000000</span></td>
                                <td>255.128.0.0</td>
                                <td>8,388,606</td>
                            </tr>
                            <tr>
                                <td>/10</td>
                                <td><span>11111111.11</span><span>000000.00000000.00000000</span></td>
                                <td>255.192.0.0</td>
                                <td>4,194,302</td>
                            </tr>
                            <tr>
                                <td>/11</td>
                                <td><span>11111111.111</span><span>00000.00000000.00000000</span></td>
                                <td>255.224.0.0</td>
                                <td>2,097,150</td>
                            </tr>
                            <tr>
                                <td>/12</td>
                                <td><span>11111111.1111</span><span>0000.00000000.00000000</span></td>
                                <td>255.240.0.0</td>
                                <td>1,048,574</td>
                            </tr>
                            <tr>
                                <td>/13</td>
                                <td><span>11111111.11111</span><span>000.00000000.00000000</span></td>
                                <td>255.248.0.0</td>
                                <td>524,286</td>
                            </tr>
                            <tr>
                                <td>/14</td>
                                <td><span>11111111.111111</span><span>00.00000000.00000000</span></td>
                                <td>255.252.0.0</td>
                                <td>262,142</td>
                            </tr>
                            <tr>
                                <td>/15</td>
                                <td><span>11111111.1111111</span><span>0.00000000.00000000</span></td>
                                <td>255.254.0.0</td>
                                <td>131,070</td>
                            </tr>
                            <tr>
                                <td>/16</td>
                                <td><span>11111111.11111111.</span><span>00000000.00000000</span></td>
                                <td>255.255.0.0</td>
                                <td>65,534</td>
                            </tr>
                            <tr>
                                <td>/17</td>
                                <td><span>11111111.11111111.1</span><span>0000000.00000000</span></td>
                                <td>255.255.128.0</td>
                                <td>32,766</td>
                            </tr>
                            <tr>
                                <td>/18</td>
                                <td><span>11111111.11111111.11</span><span>000000.00000000</span></td>
                                <td>255.255.192.0</td>
                                <td>16,382</td>
                            </tr>
                            <tr>
                                <td>/19</td>
                                <td><span>11111111.11111111.111</span><span>00000.00000000</span></td>
                                <td>255.255.224.0</td>
                                <td>8,190</td>
                            </tr>
                        </tbody>
                    </table>

                    
                    <table>
                        <thead>
                            <tr>
                                <th>CIDR</th>
                                <th>Subnet Mask (Biner)</th>
                                <th>Desimal</th>
                                <th>Usable IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>/20</td>
                                <td><span>11111111.11111111.1111</span><span>0000.00000000</span></td>
                                <td>255.255.240.0</td>
                                <td>4,094</td>
                            </tr>
                            <tr>
                                <td>/21</td>
                                <td><span>11111111.11111111.11111</span><span>000.00000000</span></td>
                                <td>255.255.248.0</td>
                                <td>2,046</td>
                            </tr>
                            <tr>
                                <td>/22</td>
                                <td><span>11111111.11111111.111111</span><span>00.00000000</span></td>
                                <td>255.255.252.0</td>
                                <td>1,022</td>
                            </tr>
                            <tr>
                                <td>/23</td>
                                <td><span>11111111.11111111.1111111</span><span>0.00000000</span></td>
                                <td>255.255.254.0</td>
                                <td>510</td>
                            </tr>
                            <tr>
                                <td>/24</td>
                                <td><span>11111111.11111111.11111111.</span><span>00000000</span></td>
                                <td>255.255.255.0</td>
                                <td>254</td>
                            </tr>
                            <tr>
                                <td>/25</td>
                                <td><span>11111111.11111111.11111111.1</span><span>0000000</span></td>
                                <td>255.255.255.128</td>
                                <td>126</td>
                            </tr>
                            <tr>
                                <td>/26</td>
                                <td><span>11111111.11111111.11111111.11</span><span>000000</span></td>
                                <td>255.255.255.192</td>
                                <td>62</td>
                            </tr>
                            <tr>
                                <td>/27</td>
                                <td><span>11111111.11111111.11111111.111</span><span>00000</span></td>
                                <td>255.255.255.224</td>
                                <td>30</td>
                            </tr>
                            <tr>
                                <td>/28</td>
                                <td><span>11111111.11111111.11111111.1111</span><span>0000</span></td>
                                <td>255.255.255.240</td>
                                <td>14</td>
                            </tr>
                            <tr>
                                <td>/29</td>
                                <td><span>11111111.11111111.11111111.11111</span><span>000</span></td>
                                <td>255.255.255.248</td>
                                <td>6</td>
                            </tr>
                            <tr>
                                <td>/30</td>
                                <td><span>11111111.11111111.11111111.111111</span><span>00</span></td>
                                <td>255.255.255.252</td>
                                <td>2</td>
                            </tr>
                            <tr>
                                <td>/31</td>
                                <td><span>11111111.11111111.11111111.1111111</span><span>0</span></td>
                                <td>255.255.255.254</td>
                                <td>2 (P2P)</td>
                            </tr>
                            <tr>
                                <td>/32</td>
                                <td><span>11111111.11111111.11111111.11111111</span></td>
                                <td>255.255.255.255</td>
                                <td>1 (Host)</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>

            <section>
                <h3>Studi Kasus 1: Subnetting /24 (Bag. 1)</h3>
                <div>
                    <p>Diberikan IP Host
                        <code><span>192.168.19</span>.<span>16</span></code>
                        yang berada di jaringan <strong>/24</strong>.
                        Tentukan blok subnetnya!
                    </p>
                    <ul>
                        <li><strong>Subnet Mask /24:</strong> <span>255.255.255</span>.<span>0</span> (Kita fokus pada oktet ke-4)</li>
                        <li>Karena /24 adalah subnet bawaan (default) kelas C, <strong>tidak ada bit
                                host yang
                                dipinjam</strong> (jumlah bit pinjaman = 0).</li>
                        <li>Jumlah Subnet = 2<sup>0</sup> = <strong>1 Blok Besar</strong>.</li>
                        <li>Jumlah IP per Blok = 2<sup>8</sup> = 256 IP (254 Host valid).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Studi Kasus 1: Subnetting /24 (Bag. 2)</h3>
                <div>
                    <div>
                        <strong>Detail Blok Subnet Tunggal (0 - 255):</strong><br><br>
                        <table>
                            <tr>
                                <td><strong>Network ID:</strong></td>
                                <td><span>192.168.19</span>.<span>0</span>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>IP Awal (Valid):</strong></td>
                                <td><span>192.168.19</span>.<span>1</span>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>IP Akhir (Valid):</strong></td>
                                <td><span>192.168.19</span>.<span>254</span>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Broadcast:</strong></td>
                                <td><span>192.168.19</span>.<span>255</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>
                        Kesimpulan: IP
                        <code><span>192.168.19</span>.<span>16</span></code>
                        merupakan host ke-16 yang valid di jaringan ini.
                    </div>
                </div>
            </section>

            <section>
                <h3>Studi Kasus 2: Subnetting /26 (Bag. 1)</h3>
                <div>
                    <p>Diberikan IP Host
                        <code><span>162.148.139</span>.<span>126</span></code>
                        yang berada di jaringan <strong>/26</strong>.
                    </p>
                    <ul>
                        <li><strong>Subnet Mask /26:</strong><br>
                            <code><span>11111111.11111111.11111111</span>.<mark>11</mark><span>000000</span></code>
                            =
                            <strong>255.255.255.192</strong>
                        </li>
                        <li>Pada oktet ke-4, ada <strong>2 bit network tambahan</strong> (pinjaman) dan
                            <strong>6 bit
                                host</strong>.
                        </li>
                        <li>Jumlah Subnet = 2<sup>2</sup> = <strong>4 Blok Subnet</strong>.</li>
                        <li>Jumlah IP per Blok = 2<sup>6</sup> = <strong>64 IP</strong> (Kelipatan
                            blok: 0, 64, 128, 192).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Studi Kasus 2: Subnetting /26 (Bag. 2)</h3>
                <div>
                    <p>Karena kita memiliki 4 blok, mari kita susun rentangnya secara berurutan:</p>
                    <div>
                        <div>
                            <strong>Blok 1 (0-63)</strong><br>
                            Net ID:
                            <code><span>162.148.139</span>.<span>0</span></code><br>
                            IP Awal:
                            <code><span>162.148.139</span>.<span>1</span></code><br>
                            IP Akhir:
                            <code><span>162.148.139</span>.<span>62</span></code><br>
                            Broadcast:
                            <code><span>162.148.139</span>.<span>63</span></code>
                        </div>
                        <div>
                            <strong>Blok 2 (64-127) 👉 IP 126 disini!</strong><br>
                            Net ID:
                            <code><span>162.148.139</span>.<span>64</span></code><br>
                            IP Awal:
                            <code><span>162.148.139</span>.<span>65</span></code><br>
                            IP Akhir:
                            <code><span>162.148.139</span>.<span>126</span></code><br>
                            Broadcast:
                            <code><span>162.148.139</span>.<span>127</span></code>
                        </div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Studi Kasus 2: Subnetting /26 (Bag. 3)</h3>
                <div>
                    <p>Lanjutan rentang 2 blok berikutnya:</p>
                    <div>
                        <div>
                            <strong>Blok 3 (128-191)</strong><br>
                            Net ID:
                            <code><span>162.148.139</span>.<span>128</span></code><br>
                            IP Awal:
                            <code><span>162.148.139</span>.<span>129</span></code><br>
                            IP Akhir:
                            <code><span>162.148.139</span>.<span>190</span></code><br>
                            Broadcast:
                            <code><span>162.148.139</span>.<span>191</span></code>
                        </div>
                        <div>
                            <strong>Blok 4 (192-255)</strong><br>
                            Net ID:
                            <code><span>162.148.139</span>.<span>192</span></code><br>
                            IP Awal:
                            <code><span>162.148.139</span>.<span>193</span></code><br>
                            IP Akhir:
                            <code><span>162.148.139</span>.<span>254</span></code><br>
                            Broadcast:
                            <code><span>162.148.139</span>.<span>255</span></code>
                        </div>
                    </div>
                    <div>
                        Kesimpulan: IP
                        <code><span>162.148.139</span>.<span>126</span></code>
                        masuk ke dalam rentang <strong>Blok 2</strong>.
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Concept Check 🎯</h3>
                <div>
                    <p>Sebelum lanjut ke VLSM, mari kita uji pemahaman Anda:</p>
                    <div>
                        <strong>Sebuah perangkat memiliki IP Address <code>192.168.1</code>.<code>70</code>
                            /27.</strong><br><br>
                        Berada di Blok Subnet manakah IP tersebut?
                    </div>
                    <ul>
                        <li><strong>Petunjuk 1:</strong> Prefix /27 meminjam 3 bit host (Jumlah Blok = 2<sup>3</sup> = 8
                            Blok).</li>
                        <li><strong>Petunjuk 2:</strong> Sisa bit host adalah 5 bit (Jumlah IP per Blok = 2<sup>5</sup>
                            = 32 IP).</li>
                        <li><strong>Petunjuk 3:</strong> Kelipatan blok adalah 0, 32, 64, 96, dst.</li>
                    </ul>
                    <div>
                        <strong>Jawaban:</strong> IP <code>192.168.1</code>.<code>70</code> berada di rentang <strong>Blok ke-3 (64 - 95)</strong>!
                    </div>
                </div>
            </section>

            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s6$qa$, $qa$jarkom-p6$qa$, $qa$Subnetting Lanjut: VLSM$qa$, $qa$<p>Variable Length Subnet Mask</p>
            </section>

            <section>
                <h3>Mengapa Butuh VLSM?</h3>
                <div>
                    <p>Metode subnetting konvensional (FLSM - <em>Fixed Length Subnet Mask</em>) memotong sebuah
                        jaringan besar menjadi blok-blok subnet dengan <strong>ukuran yang sama persis</strong>.</p>
                    <p>Masalah dengan FLSM:</p>
                    <ul>
                        <li>Bagaimana jika Gedung A butuh 100 IP, Gedung B butuh 50 IP, dan koneksi antar Router (P2P)
                            hanya butuh 2 IP?</li>
                        <li>Jika dipotong rata (misal semua /25 dengan porsi 128 IP), maka koneksi P2P akan membuang
                            percuma 126 IP address yang tidak terpakai!</li>
                    </ul>
                    <div>
                        <strong>Solusi: VLSM</strong><br>
                        VLSM adalah teknik "men-subnet kembali sebuah subnet". Memotong blok menjadi besar dan kecil
                        secara bervariasi sesuai kebutuhan riil, sehingga alokasi IP sangat efisien dan tidak terbuang.
                    </div>
                </div>
            </section>

            <section>
                <h3>Ilustrasi VLSM</h3>
                <div>
                    <div>
                        <p>Seperti memotong kue ulang tahun secara tidak rata sesuai porsi perut masing-masing orang.
                        </p>
                        <ul>
                            <li><strong>HQ (/25):</strong> Potongan besar, mencakup 128 IP (Cukup untuk 100 Host).</li>
                            <li><strong>Branch A (/26):</strong> Potongan menengah, mencakup 64 IP (Cukup untuk 50
                                Host).</li>
                            <li><strong>P2P (/30):</strong> Potongan sangat kecil, mencakup 4 IP (Cukup untuk 2 IP
                                Point-to-Point antar router).</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/vlsm.png" alt="Ilustrasi pemotongan blok VLSM">
                    </div>
                </div>
            </section>

            <section>
                <h3>Studi Kasus VLSM</h3>
                <div>
                    <p>Sebuah perusahaan memiliki IP Public <strong>192.168.10.0/24</strong> (256 IP). Perusahaan
                        tersebut memiliki 3 divisi dengan kebutuhan jumlah host sebagai berikut:</p>
                    <ul>
                        <li><strong>Gedung Pusat:</strong> Membutuhkan 100 Host</li>
                        <li><strong>Kantor Cabang:</strong> Membutuhkan 50 Host</li>
                        <li><strong>Koneksi Router (Point-to-Point):</strong> Membutuhkan 2 Host</li>
                    </ul>
                    <div>
                        <strong>Aturan Emas VLSM:</strong><br>
                        1. Selalu urutkan kebutuhan dari jumlah host yang <strong>paling besar</strong> ke yang paling
                        kecil.<br>
                        2. Tentukan Prefix (Subnet mask) terkecil yang bisa menampung kebutuhan tersebut.
                    </div>
                </div>
            </section>

            <section>
                <h3>Penyelesaian Studi Kasus VLSM (Bag. 1)</h3>
                <div>
                    <ol>
                        <li><strong>Gedung Pusat (Butuh 100 Host)</strong>
                            <ul>
                                <li>Kita butuh blok yang menyediakan &gt; 100 IP. Terdekat adalah 128 IP
                                    (<strong>/25</strong>).</li>
                                <li><strong>Detail Blok 1 (0-127):</strong>
                                    <div>
                                        <table>
                                            <tr>
                                                <td><strong>Network ID</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>0</span>/25</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>First Host (IP Awal)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>1</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Last Host (IP Akhir)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>126</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Broadcast</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>127</span></code>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Penyelesaian Studi Kasus VLSM (Bag. 2)</h3>
                <div>
                    <ol>
                        <li><strong>Kantor Cabang (Butuh 50 Host)</strong>
                            <ul>
                                <li>Lanjutkan dari akhir blok sebelumnya (.128). Kita butuh blok &gt; 50 IP. Terdekat
                                    adalah 64 IP (<strong>/26</strong>).</li>
                                <li><strong>Detail Blok 2 (128-191):</strong>
                                    <div>
                                        <table>
                                            <tr>
                                                <td><strong>Network ID</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>128</span>/26</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>First Host (IP Awal)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>129</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Last Host (IP Akhir)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>190</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Broadcast</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>191</span></code>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Penyelesaian Studi Kasus VLSM (Bag. 3)</h3>
                <div>
                    <ol>
                        <li><strong>Router P2P (Butuh 2 Host)</strong>
                            <ul>
                                <li>Lanjutkan dari akhir blok sebelumnya (.192). Kita butuh pas 2 IP Usable. Terdekat
                                    adalah 4 IP (<strong>/30</strong>).</li>
                                <li><strong>Detail Blok 3 (192-195):</strong>
                                    <div>
                                        <table>
                                            <tr>
                                                <td><strong>Network ID</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>192</span>/30</code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>First Host (IP Awal)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>193</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Last Host (IP Akhir)</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>194</span></code>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Broadcast</strong></td>
                                                <td>:
                                                    <code><span>192.168.10</span>.<span>195</span></code>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ol>
                    <div>
                        Sisa IP yang belum terpakai dari jaringan awal (196 - 255) dapat disimpan dan disubnet lagi di
                        masa depan! Sangat hemat.
                    </div>
                </div>
            </section>

            
            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s7$qa$, $qa$jarkom-p6$qa$, $qa$5. IP Version 6 (IPv6)$qa$, $qa$</section>


            <section>
                <h3>Mengapa Butuh IPv6?</h3>
                <div>
                    <ul>
                        <li><strong>IPv4 Exhaustion:</strong> Kapasitas 4,3 miliar IP dari 32-bit telah habis.</li>
                        <li><strong>Ledakan IoT:</strong> Miliaran perangkat baru (smartwatch, CCTV, dll) butuh IP
                            Public.</li>
                    </ul>
                    <p>Solusinya: IPv6 (128-bit)</p>
                    <ul>
                        <li>Kapasitas super masif: <strong>340 Undecillion</strong> (3,4 x
                            10<sup>38</sup>) IP.</li>
                        <li><em>Fun Fact:</em> Cukup untuk memberi IP Address unik pada setiap butir
                            pasir di bumi!</li>
                    </ul>
                    <div>
                        Selain kapasitas, IPv6 dirancang lebih cepat (header efisien) dan lebih aman (built-in IPSec).
                    </div>
                    <aside>
                        Jelaskan bahwa saat ini internet berkembang sangat pesat. Dengan IoT dan smartphone, setiap
                        orang punya banyak perangkat. IPv4 yang hanya 4 miliar sudah tidak relevan.
                        Itulah alasan IPv6 dibuat. Bayangkan betapa masifnya 340 Undecillion!
                    </aside>
                </div>
            </section>

            <section>
                <h3>Format IPv6</h3>
                <div>
                    <p>Karena panjangnya 128 bit, menulis IP dalam bentuk desimal akan sangat panjang dan membingungkan.
                        Oleh karena itu, IPv6 direpresentasikan menggunakan format <strong>Heksadesimal</strong>.</p>
                    <ul>
                        <li>IPv6 dibagi menjadi 8 kelompok (hextet), masing-masing dipisahkan oleh tanda titik dua
                            (<code>:</code>).</li>
                        <li>Setiap hextet bernilai <strong>16-bit</strong> (terdiri dari 4 digit heksadesimal).</li>
                        <li><strong>Contoh Penulisan:</strong> <code>2001:0db8:85a3:0000:0000:8a2e:0370:7334</code></li>
                    </ul>
                    <div>
                        <strong>Aturan Penyederhanaan:</strong>
                        <ol>
                            <li>Angka <code>0</code> di depan (Leading Zeros) dapat dihilangkan. (Contoh:
                                <code>0db8</code> menjadi <code>db8</code>)
                            </li>
                            <li>Satu atau lebih blok yang berisi <code>0000</code> berturut-turut dapat disingkat dengan
                                <code>::</code> (Hanya boleh digunakan sekali dalam satu IP).
                            </li>
                        </ol>
                    </div>
                </div>
            </section>

            <section>
                <h3>Konversi Biner ke Heksadesimal</h3>
                <div>
                    <p>Heksadesimal adalah sistem bilangan basis-16 (0-9 dan A-F). Setiap digit Heksadesimal mewakili
                        tepat <strong>4 bit (Nibble)</strong> bilangan biner.</p>

                    <div>
                        <strong>Langkah Konversi (Contoh biner: <code>11011011</code>):</strong>
                        <ol>
                            <li>Pecah deretan biner menjadi kelompok-kelompok yang berisi 4 bit (dimulai dari paling
                                kanan).<br>
                                ➔ <code>1101</code> dan <code>1011</code>
                            </li>
                            <li>Konversi masing-masing kelompok 4 bit ke padanan heksadesimalnya (Lihat tabel
                                referensi).<br>
                                ➔ <code>1101</code> adalah <strong>D</strong> (13 dalam desimal)<br>
                                ➔ <code>1011</code> adalah <strong>B</strong> (11 dalam desimal)
                            </li>
                            <li>Gabungkan hasilnya.<br>
                                ➔ Biner <code>11011011</code> = Heksadesimal <strong>DB</strong>
                            </li>
                        </ol>
                    </div>

                    <p>Tabel Referensi 4-Bit:
                    </p>
                    <table>
                        <tr>
                            <td>0=0000</td>
                            <td>4=0100</td>
                            <td>8=1000</td>
                            <td>C(12)=1100</td>
                        </tr>
                        <tr>
                            <td>1=0001</td>
                            <td>5=0101</td>
                            <td>9=1001</td>
                            <td>D(13)=1101</td>
                        </tr>
                        <tr>
                            <td>2=0010</td>
                            <td>6=0110</td>
                            <td>A(10)=1010</td>
                            <td>E(14)=1110</td>
                        </tr>
                        <tr>
                            <td>3=0011</td>
                            <td>7=0111</td>
                            <td>B(11)=1011</td>
                            <td>F(15)=1111</td>
                        </tr>
                    </table>
                </div>
            </section>

            <section>
                <h3>Konversi Heksadesimal ke Biner</h3>
                <div>
                    <p>Karena setiap Hextet pada IPv6 berisi 4 digit heksadesimal, kita bisa membedah 1 Hextet tersebut
                        kembali menjadi 16-bit (4 x 4 bit) biner utuh.</p>

                    <div>
                        <strong>Langkah Konversi (Contoh Hextet: <code>2A0F</code>):</strong>
                        <ol>
                            <li>Pisahkan setiap digit Heksadesimal.<br>
                                ➔ <code>2</code> | <code>A</code> | <code>0</code> | <code>F</code>
                            </li>
                            <li>Ganti setiap digit dengan representasi 4-bit binernya yang sesuai (Lihat tabel referensi
                                pada slide sebelumnya).<br>
                                ➔ <code>2</code> = <strong>0010</strong><br>
                                ➔ <code>A</code> = <strong>1010</strong><br>
                                ➔ <code>0</code> = <strong>0000</strong><br>
                                ➔ <code>F</code> = <strong>1111</strong>
                            </li>
                            <li>Gabungkan keseluruhan bitnya secara berurutan.<br>
                                ➔ Hextet <code>2A0F</code> = Biner <strong>0010 1010 0000 1111</strong>
                            </li>
                        </ol>
                    </div>
                    <div>
                        <strong>Contoh Praktis dari IP:</strong> <code>2001:0db8::</code><br>
                        <code>2001</code> = 0010 0000 0000 0001<br>
                        <code>0db8</code> = 0000 1101 1011 1000
                    </div>
                </div>
            </section>

            <section>
                <h3>Implementasi & Fitur Baru IPv6</h3>
                <div>
                    <p>IPv6 membuang beberapa fitur lama dari IPv4 dan membawa teknologi baru:</p>
                    <ul>
                        <li><strong>Tidak ada lagi Broadcast!</strong> Komunikasi hanya Unicast, Multicast, dan
                            <em>Anycast</em> (mengirim ke interface terdekat dari sebuah grup).
                        </li>
                        <li><strong>SLAAC (Stateless Address Autoconfiguration):</strong> Perangkat bisa men-generate
                            IPv6 address-nya sendiri secara otomatis tanpa butuh DHCP server (walaupun DHCPv6 tetap
                            ada).</li>
                        <li><strong>Header lebih ramping:</strong> Walaupun IP-nya panjang, ukuran header inti difiksasi
                            (40 bytes) sehingga router memprosesnya jauh lebih ringan dibanding IPv4.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Subnetting di IPv6</h3>
                <div>
                    <p>Subnetting IPv6 jauh lebih mudah dan logis daripada IPv4 karena ukurannya yang masif.</p>
                    <ul>
                        <li>Setiap pelanggan (misal: perusahaan atau rumah) biasanya diberikan blok <strong>/48</strong>
                            atau <strong>/56</strong> oleh ISP.</li>
                        <li>Sebuah subnet lokal (LAN) secara standar <strong>wajib</strong> menggunakan prefix
                            <strong>/64</strong>. Ini aturan mutlak agar fitur autoconfigurasi (SLAAC) bisa bekerja.
                        </li>
                    </ul>
                    <p>Struktur Umum IPv6 Unicast (/64):</p>
                    <div>
                        <div>
                            <strong>64 bit pertama (Network ID)</strong><br>
                            - 48 bit: Global Routing Prefix (dari ISP)<br>
                            - 16 bit: <strong>Subnet ID</strong> (Kapasitas: 65 ribu subnet!)
                        </div>
                        <div>
                            <strong>64 bit terakhir (Interface ID)</strong><br>
                            Identitas host/komputer. Seringkali digenerate otomatis dari MAC Address (EUI-64).
                        </div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Bagaimana dengan VLSM di IPv6?</h3>
                <div>
                    <p><strong>Fakta mengejutkan:</strong> Kita hampir tidak perlu lagi repot menghitung VLSM di IPv6!
                    </p>
                    <ul>
                        <li>Karena batas standar LAN adalah <strong>/64</strong> (yang berisi 18 <em>Quintillion</em> IP
                            Address usable), tidak ada lagi konsep "hemat IP" untuk LAN.</li>
                        <li>Semua VLAN, baik untuk 5 orang maupun 500 orang, akan diberi subnet /64 yang ukurannya
                            seragam.</li>
                    </ul>
                    <div>
                        <strong>Pengecualian (Point-to-Point):</strong><br>
                        Untuk link khusus antar dua router (P2P), RFC 6164 menyarankan penggunaan subnet
                        <strong>/127</strong> untuk alasan efisiensi tabel routing dan mencegah serangan
                        <em>ping-pong</em>. Ini adalah satu-satunya bentuk "VLSM" yang umum dipraktikkan di jaringan
                        IPv6 moderen.
                    </div>
                </div>
            </section>

            
            <section>$qa$, 7) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p6-s8$qa$, $qa$jarkom-p6$qa$, $qa$6. Konfigurasi IP Dinamis (DHCP)$qa$, $qa$</section>

            <section>
                <h3>Bagaimana Host Mendapat IP Address?</h3>
                <div>
                    <div>
                        <p>Secara umum ada 2 cara host mendapatkan IP Address:</p>
                        <ol>
                            <li><strong>Konfigurasi Statis (Manual):</strong> Teknisi memasukkan IP
                                address, Subnet Mask, Gateway, dan DNS manual di OS. Sangat merepotkan untuk jaringan
                                berskala besar.</li>
                            <li><strong>Konfigurasi Dinamis (DHCP):</strong> Host secara otomatis
                                "menyewa" (<em>lease</em>) IP dari DHCP Server setiap kali terhubung ke jaringan
                                (<em>Plug-and-play</em>).</li>
                        </ol>
                        <div>
                            Selain IP Address, DHCP Server juga wajib memberikan parameter penting lain:<br>
                            - <strong>Subnet Mask</strong><br>
                            - <strong>Default Gateway</strong> (Pintu keluar jaringan)<br>
                            - <strong>DNS Server</strong> (Penerjemah domain)
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_static_vs_dynamic.jpg" alt="Ilustrasi DHCP vs Static IP">
                    </div>
                </div>
            </section>

            <section>
                <h3>Animasi: Proses DHCP (D.O.R.A)</h3>

                <div>
                    <div>
                        <i></i>
                        <div>DHCP Client</div>
                        <div>Mencari Jaringan...</div>
                    </div>

                    <div>1. DHCP DISCOVER (Broadcast)</div>
                    <div>2. DHCP OFFER (Saya ada IP .50!)</div>
                    <div>3. DHCP REQUEST (Oke, saya sewa .50)</div>
                    <div>4. DHCP ACK (Sip, ini data lengkapnya)</div>

                    <div>
                        <i></i>
                        <div>DHCP Server</div>
                        <div>Listening (Port 67)</div>
                    </div>
                </div>

                <div>
                    <strong>Catatan:</strong> Pesan DISCOVER dari klien dikirim secara <strong>Broadcast</strong>
                    (Tujuan 255.255.255.255) karena saat itu klien belum punya IP dan tidak tahu IP address milik DHCP
                    server!
                </div>
            </section>

            <section>
                <h3>Detail Proses D.O.R.A: Discover</h3>
                <div>
                    <div>
                        <p>Proses DHCP berjalan di atas protokol <strong>UDP</strong> (Port 67 Server, Port 68 Klien).
                        </p>
                        <div>
                            <div>1. DHCP DISCOVER (Client ➔ Server)</div>
                            <div>
                                <ul>
                                    <li>Klien (laptop baru) melakukan <em>broadcast</em> untuk mencari
                                        Server DHCP yang aktif.</li>
                                    <li><strong>Source IP:</strong> <code>0.0.0.0</code> (karena belum
                                        memiliki IP).</li>
                                    <li><strong>Destination IP:</strong> <code>255.255.255.255</code>
                                        (Broadcast ke seluruh subnet).</li>
                                    <li>Membawa <em>payload</em> berisi MAC Address klien.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_discover.jpg" alt="Ilustrasi DHCP Discover">
                    </div>
                </div>
            </section>

            <section>
                <h3>Detail Proses D.O.R.A: Offer</h3>
                <div>
                    <div>
                        <p>Proses DHCP berjalan di atas protokol <strong>UDP</strong> (Port 67 Server, Port 68 Klien).
                        </p>
                        <div>
                            <div>2. DHCP OFFER (Server ➔ Client)</div>
                            <div>
                                <ul>
                                    <li>Server DHCP menerima dan merespons <em>broadcast</em> dari
                                        klien.</li>
                                    <li>Mengecek ketersediaan IP pada <strong>DHCP Pool</strong>.</li>
                                    <li>Menawarkan sebuah IP spesifik kepada MAC Address klien (contoh
                                        tawaran: <code>192.168.1.50</code>).</li>
                                    <li>Turut melampirkan masa pinjam (<em>Lease Time</em>) serta
                                        parameter pendukung.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_offer.jpg" alt="Ilustrasi DHCP Offer">
                    </div>
                </div>
            </section>
            <section>
                <h3>Detail Proses D.O.R.A: Request</h3>
                <div>
                    <div>
                        <div>
                            <div>3. DHCP REQUEST (Client ➔ Server)</div>
                            <div>
                                <ul>
                                    <li>Klien merespons tawaran server untuk
                                        <strong>menerimanya</strong> secara formal.
                                    </li>
                                    <li>Pesan dikirim secara <strong>Broadcast</strong> kembali.</li>
                                    <li><strong>Mengapa Broadcast?</strong> Karena di dalam sebuah
                                        jaringan skala besar bisa saja terdapat lebih dari 1 DHCP Server.</li>
                                    <li>Dengan menyiarkan pesan secara <em>broadcast</em>, klien
                                        menginformasikan server pilihannya sekaligus memberitahu DHCP server
                                        <em>lainnya</em> bahwa tawaran mereka <strong>ditolak</strong>.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_request.jpg" alt="Ilustrasi DHCP Request">
                    </div>
                </div>
            </section>
            <section>
                <h3>Detail Proses D.O.R.A: Ack</h3>
                <div>
                    <div>
                        <div>
                            <div>4. DHCP ACKNOWLEDGE (Server ➔ Client)</div>
                            <div>
                                <ul>
                                    <li>Server DHCP merespons <em>Request</em> klien dengan konfirmasi
                                        akhir.</li>
                                    <li>Server secara resmi mencatat ikatan (<em>binding</em>) MAC
                                        Address klien dengan IP tersebut di dalam <strong>Lease Table</strong> miliknya.
                                    </li>
                                    <li>Pesan ACK melampirkan bundel utuh parameter jaringan (IP, Mask,
                                        Gateway, DNS, Lease Time).</li>
                                    <li>Klien selesai! Konfigurasi jaringan langsung terpasang otomatis
                                        dan siap digunakan.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_ack.jpg" alt="Ilustrasi DHCP Acknowledge">
                    </div>
                </div>
            </section>

            <section>
                <h3>Bagaimana Jika DHCP Gagal? (APIPA)</h3>
                <div>
                    <div>
                        <p>Jika <strong>DHCP DISCOVER</strong> klien tidak mendapat balasan (karena server mati atau
                            kabel terputus), apa yang terjadi?</p>
                        <ul>
                            <li>Sistem Operasi (Windows/macOS) melakukan <em>fallback</em> otomatis
                                menggunakan fitur <strong>APIPA (Automatic Private IP Addressing)</strong>.</li>
                            <li>Klien secara mandiri menetapkan IP acak pada rentang
                                <strong>169.254.0.1 - 169.254.255.254</strong> (Prefix /16).
                            </li>
                            <li><strong>Dampaknya:</strong> Klien TIDAK memiliki default gateway. Klien
                                tidak bisa mengakses internet, tapi tetap bisa berkomunikasi lokal dengan komputer lain
                                yang sama-sama ber-APIPA.</li>
                        </ul>
                        <div>
                            &#x1F4A1; <strong>Tips Teknisi:</strong> Jika IP Anda <code>169.254.x.x</code>, itu
                            mengindikasikan koneksi fisik/WiFi (layer 1 & 2) bagus, namun layanan DHCP di jaringan
                            rusak!
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week6/dhcp_apipa.jpg" alt="Ilustrasi DHCP Failure / APIPA">
                    </div>
                </div>
            </section>
            
            <section>
                <h3>Rangkuman Pertemuan 6</h3>
                <div>
                    <div>
                        <p>Network Layer & IPv4/v6</p>
                        <ul>
                            <li><strong>Forwarding & Routing:</strong> Mekanisme lokal vs global.</li>
                            <li><strong>IPv4:</strong> 32-bit, habis, menggunakan Subnet Mask kaku atau CIDR.</li>
                            <li><strong>IPv6:</strong> 128-bit heksadesimal, auto-config, tanpa broadcast.</li>
                        </ul>
                    </div>
                    <div>
                        <p>Subnetting, VLSM & DHCP</p>
                        <ul>
                            <li><strong>Subnetting:</strong> Meminjam bit host untuk memecah network besar.</li>
                            <li><strong>VLSM:</strong> Memecah subnet tidak rata demi efisiensi IP.</li>
                            <li><strong>DHCP:</strong> Automasi penyewaan IP dengan proses 4 tahap D.O.R.A.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <div>
                    <h3>📝 Tugas Individu — Pertemuan 6</h3>
                    <p>Dikerjakan analitik, ditulis tangan di
                        kertas folio, difoto, dikirim ke e-learning.</p>

                    <div>
                        <p><span>1.</span> Kantor pusat ITERA diberikan blok IP Public
                            <strong>202.10.50.0/24</strong>. Biro A membutuhkan alokasi untuk 60 host, Biro B butuh 30
                            host, dan Biro C butuh 10 host. Lakukan rancangan subnetting dengan metode <strong>VLSM
                                (Variable Length Subnet Mask)</strong> agar alokasinya efisien (tidak buang-buang IP).
                            Tuliskan detail Network ID, Subnet Mask (dalam notasi slash), Range IP Valid, dan Broadcast
                            ID untuk setiap Biro!
                        </p>
                    </div>

                    <div>
                        <p><span>2.</span> Anda menyambungkan laptop ke WiFi publik di sebuah kafe. Anda
                            dapat terhubung ke access point, namun ada tanda seru kuning "No Internet Access". Ketika
                            dicek, IP Address laptop Anda adalah <strong>169.254.x.x</strong> (APIPA). Berdasarkan
                            pemahaman proses DHCP (DORA), jelaskan di tahap manakah proses konfigurasi IP Anda gagal,
                            dan mengapa OS memberikan IP tersebut?</p>
                    </div>

                    <div>
                        <div><i></i> Tulis tangan (Folio)</div>
                        <div><i></i> Scan PDF/Foto ke E-Learning</div>
                    </div>
                </div>
            </section>


            <section>$qa$, 8) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-c1$qa$, $qa$jarkom-p6$qa$, $qa$checkpoint$qa$, $qa$Subnet /26 mempunyai jumlah alamat IP total sebanyak...$qa$, $qa$["32", "64", "128", "16"]$qa$::jsonb, 1, $qa$32 - 26 = 6 bit host, 2^6 = 64 alamat (62 bisa dipakai host).$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-c2$qa$, $qa$jarkom-p6$qa$, $qa$checkpoint$qa$, $qa$Protokol yang memberi alamat IP otomatis ke perangkat adalah...$qa$, $qa$["DNS", "SMTP", "DHCP", "FTP"]$qa$::jsonb, 2, $qa$DHCP menyewakan IP, gateway, dan DNS secara otomatis.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-c3$qa$, $qa$jarkom-p6$qa$, $qa$checkpoint$qa$, $qa$Alamat IPv4 bersifat 32-bit, sedangkan IPv6...$qa$, $qa$["16-bit", "48-bit", "64-bit", "128-bit"]$qa$::jsonb, 3, $qa$IPv6 memakai 128-bit sehingga ruang alamatnya sangat besar.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-b1$qa$, $qa$jarkom-p6$qa$, $qa$battle$qa$, $qa$Sebuah subnet memakai prefix /26. Berapa jumlah IP yang bisa dipakai host?$qa$, $qa$["64", "62", "30", "126"]$qa$::jsonb, 1, $qa$Bit host = 32-26 = 6, total 2^6 = 64 alamat dikurangi network ID dan broadcast = 62 usable.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-b2$qa$, $qa$jarkom-p6$qa$, $qa$battle$qa$, $qa$Perangkat ber-IP 192.168.1.70/27 berada di blok subnet...$qa$, $qa$["192.168.1.0 - 192.168.1.31", "192.168.1.32 - 192.168.1.63", "192.168.1.64 - 192.168.1.95", "192.168.1.96 - 192.168.1.127"]$qa$::jsonb, 2, $qa$/27 berarti blok kelipatan 32 (256-224=32); 70 jatuh pada rentang 64-95 dengan network ID .64.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-b3$qa$, $qa$jarkom-p6$qa$, $qa$battle$qa$, $qa$Kantor butuh 100 IP untuk gedung A, 50 untuk gedung B, dan 2 untuk link antar-router. Pendekatan terbaik...$qa$, $qa$["Bagi rata menjadi tiga subnet /25 (FLSM)", "VLSM: /25 untuk A, /26 untuk B, /30 untuk link router", "Satu subnet /24 tanpa dibagi", "Masing-masing diberi /30"]$qa$::jsonb, 1, $qa$VLSM memotong blok sesuai kebutuhan (aturan emas: urutkan dari terbesar) sehingga tidak ada IP terbuang sia-sia.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-b4$qa$, $qa$jarkom-p6$qa$, $qa$battle$qa$, $qa$Dalam proses DORA, mengapa DHCP DISCOVER dikirim sebagai broadcast?$qa$, $qa$["Agar semua host mendapat IP baru", "Karena klien belum punya IP dan belum tahu alamat server DHCP", "Karena DHCP memakai TCP yang butuh broadcast", "Agar router meneruskannya ke internet"]$qa$::jsonb, 1, $qa$Klien yang baru terhubung belum punya identitas jaringan, jadi satu-satunya cara menemukan server adalah broadcast ke 255.255.255.255.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p6-b5$qa$, $qa$jarkom-p6$qa$, $qa$battle$qa$, $qa$Laptop mendapat IP 169.254.10.5 dan tidak bisa akses internet. Artinya...$qa$, $qa$["Kabel LAN putus total", "DHCP gagal sehingga OS memakai APIPA; tidak ada default gateway", "DNS server sedang down", "IP tersebut adalah IP publik"]$qa$::jsonb, 1, $qa$Rentang 169.254.0.0/16 (APIPA) adalah fallback saat DISCOVER tak berbalas; komunikasi hanya bisa lokal sesama APIPA.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
