insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p5$qa$, $qa$jarkom$qa$, $qa$Lapisan Transport$qa$, $qa$<h3>Peran Transport Layer</h3>
<p>Menyediakan komunikasi logis <strong>process-to-process</strong> (ujung ke ujung antar aplikasi), sedangkan network layer hanya host-to-host. Analogi: network layer mengantar paket ke pos satpam asrama, transport layer menyortirnya ke kamar mahasiswa yang tepat.</p>
<ul>
<li><strong>Multiplexing</strong> (pengirim): kumpulkan data banyak soket jadi satu aliran. <strong>Demultiplexing</strong> (penerima): pilah berdasar port.</li>
<li><strong>UDP demux:</strong> 2-tuple (IP tujuan, port tujuan) — satu soket melayani semua klien. <strong>TCP demux:</strong> 4-tuple (IP & port sumber-tujuan) — tiap koneksi soket sendiri.</li>
</ul>
<h3>UDP — Cepat Tapi Tak Andal</h3>
<p>Connectionless, tanpa handshake, tanpa jaminan sampai/urutan, tanpa congestion control. Dipakai saat <strong>kecepatan lebih penting dari keutuhan</strong>: game online, live streaming, VoIP, DNS. Tetap punya checksum untuk deteksi error.</p>
<h3>Reliable Data Transfer</h3>
<ul>
<li><strong>RTT:</strong> waktu paket pergi + ACK kembali; menentukan efisiensi bandwidth.</li>
<li><strong>RTO:</strong> timer habis tanpa balasan (paket hilang diam-diam). <strong>Destination unreachable:</strong> router aktif mengirim error ICMP karena rute tak ada.</li>
<li><strong>Stop-and-wait:</strong> kirim 1 paket, tunggu ACK — utilisasi buruk. <strong>Pipelining:</strong> kirim banyak sekaligus.</li>
<li><strong>Go-Back-N:</strong> ACK kumulatif; paket hilang = kirim ulang semua setelahnya (boros). <strong>Selective Repeat:</strong> ACK individual + buffer out-of-order; hanya yang hilang dikirim ulang (efisien).</li>
</ul>
<h3>TCP — Andal & Terurut</h3>
<ul>
<li>Connection-oriented, reliable in-order byte stream, full-duplex, point-to-point. Field penting: source/dest port, sequence number, acknowledgement number, flags (SYN, ACK, FIN), receive window.</li>
<li><strong>3-way handshake:</strong> SYN lalu SYN-ACK lalu ACK. <strong>Teardown 4 langkah:</strong> FIN/ACK tiap arah.</li>
<li><strong>Timeout adaptif:</strong> TimeoutInterval = EstimatedRTT + 4 x DevRTT. <strong>Fast retransmit:</strong> 3 duplicate ACK = kirim ulang segera tanpa tunggu timeout.</li>
</ul>
<h3>Flow Control vs Congestion Control</h3>
<ul>
<li><strong>Flow control:</strong> melindungi <strong>buffer penerima</strong> — penerima mengumumkan ruang kosong lewat <strong>rwnd</strong>.</li>
<li><strong>Congestion control:</strong> melindungi <strong>buffer router</strong> — algoritma <strong>AIMD</strong>: naik perlahan (+1 MSS per RTT), turun drastis (potong setengah saat loss) membentuk pola gigi gergaji. Fase: <strong>slow start</strong> (eksponensial), <strong>congestion avoidance</strong> (linier), <strong>fast recovery</strong>.</li>
</ul>
<h3>QUIC</h3>
<p>Evolusi transport untuk HTTP/3 di atas UDP: handshake 0-1 RTT (vs 2-3 RTT pada TCP+TLS) dan tanpa head-of-line blocking berkat streams independen.</p>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan05.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 5) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s1$qa$, $qa$jarkom-p5$qa$, $qa$Lapisan Transport$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>

            
            <section>
                <div>
                    
                    <h3>Pertemuan 5</h3>
                </div>
                <p>Referensi Utama: Kurose &amp; Ross — <em>Computer Networking: A Top-Down Approach (8th Ed)</em></p>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
                <aside>Hari ini kita akan masuk ke lapisan Transport. Lapisan ini sangat penting karena
                    berada persis di bawah aplikasi kita, menyediakan komunikasi ujung-ke-ujung yang sebenarnya.</aside>
            </section>

            
            <section>
                <h3>Outline Materi</h3>
                <div>
                    <div>
                        <p>Bagian 1: Konsep Transport &amp; UDP</p>
                        <ul>
                            <li>1. Layanan Lapisan Transport</li>
                            <li>2. Multiplexing &amp; Demultiplexing</li>
                            <li>3. User Datagram Protocol (UDP)</li>
                            <li>4. Prinsip Reliable Data Transfer (RDT)</li>
                        </ul>
                    </div>
                    <div>
                        <p>Bagian 2: TCP &amp; Protokol Modern</p>
                        <ul>
                            <li>5. Transmission Control Protocol (TCP)</li>
                            <li>6. Manajemen Koneksi TCP</li>
                            <li>7. Flow Control (Kendali Aliran)</li>
                            <li>8. TCP Congestion Control</li>
                            <li>9. Evolusi Transport Layer (QUIC)</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s2$qa$, $qa$jarkom-p5$qa$, $qa$1. Layanan Lapisan Transport$qa$, $qa$</section>

            <section>
                <h3>Peran Transport Layer</h3>
                <div>
                    <p>Menyediakan komunikasi <strong>logis ujung-ke-ujung (end-to-end)</strong> antara proses aplikasi
                        yang berjalan di host yang berbeda.</p>
                    <ul>
                        <li><strong>Network Layer:</strong> Komunikasi logis antar <strong>Host</strong> (komputer).
                        </li>
                        <li><strong>Transport Layer:</strong> Komunikasi logis antar <strong>Proses</strong>
                            (aplikasi/socket).</li>
                    </ul>
                    <div>
                        💡 <strong>Analogi Asrama Mahasiswa (Kost-kostan):</strong>
                        <br>Gedung Asrama = <strong>Host</strong> (Komputer/HP)
                        <br>Mahasiswa di kamar = <strong>Proses</strong> (Aplikasi: Chrome, Spotify, Zoom)
                        <br>Kurir Paket = <strong>Network Layer</strong> (Hanya mengantar paket sampai ke pos satpam
                        asrama)
                        <br>Satpam Asrama = <strong>Transport Layer</strong> (Mensortir dan menyalurkan paket ke kamar
                        mahasiswa yang tepat)
                    </div>
                </div>
            </section>

            <section>
                <h3>Ilustrasi Peran Transport Layer</h3>
                <div>
                    <div>
                        <div>Analogi Asrama Mahasiswa</div>
                        <div>
                            <p><strong>Bagian Kiri (Network Layer):</strong> <br>
                                Kurir paket JNE hanya bertugas mengantar barang melalui jaringan jalan umum sampai ke
                                <strong>Pos Gerbang Asrama (Host)</strong>.
                            </p>
                            <br>
                            <p><strong>Bagian Kanan (Transport Layer):</strong> <br>
                                Satpam di dalam gedung asrama bertugas menyortir paket dan mengantarkannya langsung ke
                                <strong>pintu kamar mahasiswa (Proses/Aplikasi)</strong> yang bersangkutan.
                            </p>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/ilustrasi_asrama.jpg" alt="Ilustrasi Analogi Asrama untuk Transport Layer">
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Komunikasi Proses ke Proses</h3>
                <div>
                    <div>Proses ↔ Proses
                    </div>
                    <div>
                        <div>
                            <div>
                                Browser (Proses A)</div>
                            <div>
                                TCP (Transport)</div>
                        </div>
                        <div>
                            <i></i>
                            <span>Jaringan Internet (IP)</span>
                        </div>
                        <div>
                            <div>
                                Web Server (Proses B)</div>
                            <div>
                                TCP (Transport)</div>
                        </div>
                    </div>
                    <div>
                        Tugas utama transport layer adalah mengambil pesan dari aplikasi, memecahnya menjadi
                        segmen-segmen kecil (jika perlu), dan menyerahkannya ke network layer. Di sisi penerima,
                        menyusunnya kembali dan menyerahkannya ke aplikasi yang tepat.
                    </div>
                </div>
            </section>
            <section>
                <h3>Ilustrasi: Komunikasi Proses ke Proses</h3>
                <div>
                    <img src="https://informatika-itera.github.io/jarkom/img/week5/proses_komunikasi.jpg" alt="Ilustrasi Komunikasi Proses ke Proses">
                </div>
                <div>
                    <strong>Transport layer</strong> mengambil pesan dari aplikasi (misal: Browser), menyerahkannya ke
                    network layer, dikirim melalui internet. Di sisi penerima, pesan diserahkan kembali ke aplikasi yang
                    tepat (misal: Web Server).
                </div>
            </section>


            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s3$qa$, $qa$jarkom-p5$qa$, $qa$2. Multiplexing & Demultiplexing$qa$, $qa$</section>

            <section>
                <h3>Konsep Mux &amp; Demux</h3>
                <div>
                    <div>
                        <div>Di Sisi Pengirim (Multiplexing)</div>
                        <div>
                            Mengumpulkan data dari banyak soket (aplikasi), menambahkan header transport (yang nantinya
                            dipakai untuk demultiplexing), dan meneruskannya ke Network Layer lewat satu saluran.
                        </div>
                        <div>Di Sisi Penerima
                            (Demultiplexing)</div>
                        <div>
                            Menggunakan informasi header (<strong>Port Numbers</strong>) untuk memilah dan mengantarkan
                            segmen yang masuk ke soket yang tepat.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/mux_demux.png" alt="Ilustrasi Multiplexing dan Demultiplexing">
                    </div>
                </div>
            </section>

            <section>
                <h3>Demultiplexing: UDP</h3>
                <div>
                    <p><strong>Connectionless Demux (UDP)</strong></p>
                    <ul>
                        <li>Soket UDP diidentifikasi sepenuhnya oleh <strong>2-tuple</strong>:
                            <code>(Dest IP, Dest Port)</code>.
                        </li>
                        <li>Jika dua datagram dari IP pengirim (sumber) yang berbeda, atau dari Port sumber yang
                            berbeda, menuju <strong>Port Tujuan yang sama</strong>, keduanya akan masuk ke <strong>satu
                                soket UDP yang sama</strong>.</li>
                        <li>Sangat efisien untuk server yang melayani banyak klien sekaligus tanpa perlu melacak status
                            tiap klien (contoh: DNS Server di Port 53).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Demultiplexing: TCP</h3>
                <div>
                    <p><strong>Connection-Oriented Demux (TCP)</strong></p>
                    <ul>
                        <li>Soket TCP diidentifikasi secara unik oleh <strong>4-tuple</strong>:
                            <code>(Src IP, Src Port, Dest IP, Dest Port)</code>.
                        </li>
                        <li>Host penerima menggunakan <em>keempat</em> nilai ini untuk mengarahkan segmen ke soket yang
                            tepat.</li>
                        <li>Web server (Apache/Nginx) membuat <strong>soket baru yang terpisah</strong> untuk
                            <em>setiap</em> koneksi klien yang masuk, meskipun semuanya menuju port tujuan yang sama
                            (Port 80/443).
                        </li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Perbandingan Demux UDP vs TCP</h3>
                <div>
                    <div>
                        <p>UDP Demux</p>
                        <div>
                            Client A (IP: A, Port: 111) ──┐<br>
                            Client B (IP: B, Port: 222) ──┼─▶ Socket (Port 53)<br>
                            Client C (IP: C, Port: 333) ──┘
                        </div>
                        <p>Satu pintu (soket) melayani semua tamu yang datang ke alamat
                            tersebut.</p>
                    </div>
                    <div>
                        <p>TCP Demux</p>
                        <div>
                            Client A (IP: A, Port: 111) ──▶ Socket 1 (Port 80)<br>
                            Client B (IP: B, Port: 222) ──▶ Socket 2 (Port 80)<br>
                            Client C (IP: C, Port: 333) ──▶ Socket 3 (Port 80)
                        </div>
                        <p>Setiap tamu (klien) dilayani di ruangan (soket) khusus yang berbeda,
                            meskipun datang ke gedung (port) yang sama.</p>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s4$qa$, $qa$jarkom-p5$qa$, $qa$3. User Datagram Protocol (UDP)$qa$, $qa$</section>

            <section>
                <h3>UDP: Cepat Tapi Tidak Andal</h3>
                <div>
                    <div>
                        <ul>
                            <li><strong>No Frills, Bare Bones:</strong> Protokol transport yang sangat minimalis (RFC
                                768).</li>
                            <li><strong>Connectionless:</strong> Tidak ada proses handshaking sebelum mengirim data.
                                Langsung tembak!</li>
                            <li><strong>Best Effort:</strong> Segmen UDP dapat hilang (lost) atau datang tidak berurutan
                                (out of order).</li>
                            <li><strong>No Congestion Control:</strong> UDP tidak peduli jaringan sedang macet, ia akan
                                terus mengirim data.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_vs_udp.png" alt="Perbandingan TCP dan UDP">
                    </div>
                </div>
            </section>

            <section>
                <h3>Mengapa UDP Masih Digunakan?</h3>
                <div>
                    <p>Meskipun tidak andal, UDP memiliki keunggulan telak dalam skenario tertentu:</p>
                    <ul>
                        <li><strong>Tanpa delay setup:</strong> Tidak perlu menunggu 3-way handshake selesai untuk mulai
                            mengirim data (Sangat penting untuk DNS query yang butuh respon instan).</li>
                        <li><strong>Tanpa state koneksi:</strong> Server tidak perlu menyimpan informasi buffer atau
                            parameter koneksi klien, sehingga memori jauh lebih hemat.</li>
                        <li><strong>Header sangat kecil:</strong> Hanya 8 byte overhead (dibandingkan TCP yang 20 byte).
                        </li>
                        <li><strong>Kontrol penuh di level aplikasi:</strong> Aplikasi bisa mengontrol kapan tepatnya
                            data dikirim tanpa dihalangi oleh algoritma congestion control TCP.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Pentingnya UDP:</h3>
                <h4>Real-time &amp; Low Latency</h4>
                <div>
                    <div>
                        <p>Dalam aplikasi real-time, <strong>kecepatan lebih penting daripada keutuhan 100%</strong>.
                        </p>
                        <ul>
                            <li>🎮 <strong>Game Online:</strong> Kehilangan satu paket data pergerakan pemain tidak
                                masalah, asalkan paket berikutnya datang sangat cepat tanpa delay. Jika menggunakan TCP,
                                retransmisi akan menyebabkan <em>lag/stuttering</em>.</li>
                            <li>📺 <strong>Live Streaming / VoIP:</strong> Hilangnya paket hanya menyebabkan sedikit
                                glitch visual/audio sementara, yang lebih bisa ditoleransi manusia daripada video yang
                                terus-terusan berhenti untuk <em>buffering</em>.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/udp_importance.png" alt="Ilustrasi pentingnya UDP untuk Gaming dan Streaming">
                    </div>
                </div>
            </section>

            <section>
                <h3>UDP Checksum</h3>
                <div>
                    <div>
                        <div>Fungsi Checksum</div>
                        <div>
                            <ul>
                                <li>Meskipun UDP tidak andal, ia menyediakan fungsi <strong>deteksi error</strong>
                                    minimum melalui <em>Checksum</em>.</li>
                                <li><strong>Tujuan:</strong> Mendeteksi "bit yang berubah" (error) di dalam segmen yang
                                    ditransmisikan.</li>
                            </ul>
                        </div>
                        <div>Sisi Pengirim</div>
                        <div>
                            <ul>
                                <li>Memperlakukan segmen (termasuk header dan data) sebagai urutan integer 16-bit.</li>
                                <li><strong>Checksum:</strong> Hasil penjumlahan seluruh 16-bit word menggunakan <em>1's
                                        complement arithmetic</em>, kemudian dibalik (complement).</li>
                                <li>Nilai ini dimasukkan ke field <em>checksum</em> di header UDP.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Sisi Penerima</div>
                        <div>
                            <ul>
                                <li>Penerima menjumlahkan semua 16-bit word yang diterima beserta checksum-nya.</li>
                                <li>Jika tidak ada error, hasil penjumlahan (1's complement) harus berupa kumpulan bit
                                    <code>1</code> (semuanya bernilai 1).
                                </li>
                                <li>Jika ada setidaknya satu bit <code>0</code>, maka <strong>error terdeteksi</strong>,
                                    dan segmen UDP biasanya akan dibuang (di-drop).</li>
                            </ul>
                            <div>
                                <strong>Keterbatasan:</strong> Checksum UDP lemah dibandingkan CRC pada Data Link Layer,
                                namun sangat cepat dihitung dalam perangkat lunak (software).
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s5$qa$, $qa$jarkom-p5$qa$, $qa$4. Prinsip Reliable Data Transfer (RDT)$qa$, $qa$</section>

            <section>
                <h3>Reliable Data Transfer (RDT)</h3>
                <div>
                    <div>
                        <p><strong>Tantangan Utama:</strong></p>
                        <p>Bagaimana membangun layanan komunikasi yang <strong>andal</strong> (tidak ada data hilang,
                            rusak, atau tertukar urutannya) di atas saluran fisik/jaringan yang <strong>tidak
                                andal</strong> (unreliable channel)?</p>
                        <div>Mekanisme Dasar RDT</div>
                        <div>
                            <ul>
                                <li><strong>Error Detection:</strong> Checksum (mendeteksi bit error).</li>
                                <li><strong>Receiver Feedback:</strong>
                                    <ul>
                                        <li><strong>ACK</strong> (Acknowledgement): Berhasil diterima.</li>
                                        <li><strong>NAK</strong> (Negative ACK): Gagal/Rusak.</li>
                                    </ul>
                                </li>
                                <li><strong>Retransmission:</strong> Mengirim ulang paket yang rusak/hilang.</li>
                                <li><strong>Sequence Number:</strong> Menandai urutan paket agar penerima tahu jika ada
                                    paket duplikat atau hilang.</li>
                                <li><strong>Timer:</strong> Untuk mendeteksi paket yang hilang di jalan (Timeout).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/rdt_ilustrasi.jpg" alt="Ilustrasi Mekanisme Reliable Data Transfer">
                        <div>Ilustrasi Mekanisme RDT
                            (Timer, Sequence, Feedback, &amp; Error Detection)</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Apa itu RTT (Round-Trip Time)?</h3>
                <div>
                    <div>
                        <p><strong>Round-Trip Time (RTT)</strong> adalah total waktu yang dibutuhkan oleh sebuah paket
                            data untuk melakukan perjalanan dari pengirim menuju penerima, ditambah dengan waktu
                            kembalinya sinyal konfirmasi (ACK) ke pengirim.</p>
                        <p>Singkatnya: <strong>Waktu sejak paket dikirim sampai konfirmasi
                                diterima.</strong></p>
                        <ul>
                            <li>RTT sangat dipengaruhi oleh jarak fisik dan panjang kabel penghubung.</li>
                            <li>Turut dipengaruhi oleh waktu antrean pemrosesan di router (Queueing Delay).</li>
                            <li><strong>Mengapa Penting?</strong> Nilai RTT sangat menentukan seberapa efisien kapasitas
                                bandwidth bisa dimanfaatkan.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/rtt_illustration.jpg" alt="Ilustrasi RTT">
                        <div>RTT = Total Waktu
                            Bolak-Balik Paket dan ACK</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Studi Kasus: Request Time Out (RTO)</h3>
                <div>
                    <div>
                        <p>Apa yang terjadi?</p>
                        <p>Pengirim berhasil melempar paket ke jaringan, dan paket tersebut sedang mengalir mencari
                            jalan. Namun, hingga <em>timer</em> (waktu tunggu) habis, tidak ada balasan sama sekali yang
                            kembali ke pengirim.</p>
                        <p>Penyebab Umum:</p>
                        <ul>
                            <li>Paket ditolak secara diam-diam (di-drop) oleh <strong>Firewall</strong> di sisi penerima
                                atau router tengah.</li>
                            <li>Jaringan sangat macet (Congestion), sehingga paket terbuang dari antrean (Packet Loss).
                            </li>
                            <li>Server tujuan sedang mati/hang sehingga tidak merespon paket yang datang.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/rto_illustration.jpg" alt="Ilustrasi Request Time Out">
                        <div>Waktu tunggu (timer) habis
                            sebelum balasan tiba</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Studi Kasus: Destination Unreachable</h3>
                <div>
                    <div>
                        <p>Apa yang terjadi?</p>
                        <p>Paket bahkan tidak pernah sampai mendekati tujuan. Dalam perjalanannya, sebuah Router (atau
                            PC pengirim itu sendiri) menyadari bahwa jalan menuju ke sana <strong>tidak ada</strong>
                            atau terputus, lalu secara aktif mengirimkan pesan eror (ICMP) kembali ke pengirim.</p>
                        <p>Penyebab Umum:</p>
                        <ul>
                            <li>Kabel jaringan putus atau interface jaringan mati (Link Down).</li>
                            <li>Tidak ada entri di tabel routing (No Route to Host).</li>
                            <li>Salah konfigurasi IP atau Gateway.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/unreachable_illustration.jpg" alt="Ilustrasi Destination Unreachable">
                        <div>Router mengirim pesan eror
                            eksplisit: Jalur Putus</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Perbandingan: RTO vs Unreachable</h3>
                <div>
                    <table>
                        <tr>
                            <th>Aspek</th>
                            <th>Request Time Out (RTO)</th>
                            <th>Destination Unreachable</th>
                        </tr>
                        <tr>
                            <td>Status Jalan</td>
                            <td>Rute jalannya ada, tapi paket "hilang" di jalan atau tujuan.</td>
                            <td>Rute jalannya benar-benar tidak diketahui/terputus.</td>
                        </tr>
                        <tr>
                            <td>Respons Jaringan</td>
                            <td><strong>Diam (Silent Drop).</strong> Tidak ada info apa-apa yang
                                kembali.</td>
                            <td><strong>Aktif (Eksplisit).</strong> Router mengirim notifikasi
                                eror ICMP.</td>
                        </tr>
                        <tr>
                            <td>Analogi Kehidupan</td>
                            <td>Kirim barang lewat kurir, tapi kurirnya lenyap di jalan. Kita
                                menunggu tanpa kepastian sampai bosan.</td>
                            <td>Kirim barang lewat kurir, tapi baru sampai gang depan ditolak
                                satpam: "Alamat ini tidak ada!".</td>
                        </tr>
                    </table>
                </div>
            </section>

            <section>
                <h3>Evolusi RDT &amp; Pipelining (1)</h3>
                <div>
                    <div>
                        <div>Pendekatan "Stop-and-Wait" (rdt3.0)</div>
                        <div>
                            <ul>
                                <li>Pengirim mengirim 1 paket, lalu <strong>menunggu</strong> ACK dari penerima sebelum
                                    mengirim paket berikutnya.</li>
                                <li><strong>Kelemahan Utama:</strong> Utilisasi jaringan
                                    sangat buruk! Kapasitas link
                                    (bandwidth) yang besar terbuang percuma karena dihabiskan untuk waktu tunggu
                                    propagasi sinyal (RTT) yang mendominasi.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/stop_and_wait.jpg" alt="Ilustrasi Stop-and-Wait">
                        <div>Ilustrasi waktu terbuang
                            saat menunggu paket ACK.</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Evolusi RDT &amp; Pipelining (2)</h3>
                <div>
                    <div>

                        <div>Solusi: Pipelining</div>
                        <div>
                            <ul>
                                <li>Pengirim diperbolehkan mengirim banyak paket sekaligus secara berturut-turut tanpa
                                    harus menunggu ACK dari paket sebelumnya.
                                </li>
                                <li>Dengan ini utilisasi link jauh lebih optimal karena
                                    pengirim tidak membuang waktu menunggu (gap kosong berkurang drastis).</li>
                                <li>Membutuhkan <em>sequence number</em> yang lebih besar dan
                                    <em>buffer</em> (tempat penyimpanan sementara) di
                                    pengirim/penerima.
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/pipelining_concept.jpg" alt="Ilustrasi Konsep Pipelining">
                        <div>Ilustrasi aliran paket yang
                            dikirimkan tanpa jeda menunggu ACK.</div>
                    </div>

                </div>
            </section>

            <section>
                <h3>Evolusi RDT &amp; Pipelining (3)</h3>
                <div>
                    <div>
                        <div>Dua Pendekatan Pipelining</div>
                        <div>
                            <ul>
                                <li><strong>Go-Back-N (GBN):</strong>
                                    <ul>
                                        <li>Penerima mengirimkan <em>Cumulative ACK</em>.</li>
                                        <li>Jika terjadi timeout pada paket <var>n</var>, pengirim mentransmisikan ulang
                                            paket <var>n</var> dan <strong>semua</strong> paket setelahnya (Sangat boros
                                            bandwidth).</li>
                                    </ul>
                                </li>
                                <li><strong>Selective Repeat (SR):</strong>
                                    <ul>
                                        <li>Penerima mengirimkan ACK secara individual tiap paket.</li>
                                        <li>Penerima mem-buffer paket yang <em>out-of-order</em>.</li>
                                        <li>Pengirim hanya mentransmisikan ulang paket yang benar-benar hilang/timeout
                                            (Lebih efisien).</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/gbn_vs_sr.jpg" alt="Ilustrasi Go-Back-N vs Selective Repeat">
                        <div>Perbandingan inefisiensi
                            GBN vs efisiensi SR saat terjadi paket error.</div>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s6$qa$, $qa$jarkom-p5$qa$, $qa$5. Transmission Control Protocol (TCP)$qa$, $qa$</section>

            <section>
                <h3>Struktur Segmen TCP</h3>
                <div>
                    <div>
                        <ul>
                            <li><strong>Source &amp; Dest Port (16-bit):</strong> Untuk multiplexing &amp;
                                demultiplexing.</li>
                            <li><strong>Sequence Number (32-bit):</strong> Nomor urut byte pertama dari data dalam
                                segmen ini (bukan nomor segmen).</li>
                            <li><strong>Acknowledgement Number (32-bit):</strong> Nomor urut byte <em>selanjutnya</em>
                                yang diharapkan dari pihak lawan (Cumulative ACK).</li>
                            <li><strong>Header Length (4-bit):</strong> Panjang header (karena ada field Option yang
                                bervariasi).</li>
                            <li><strong>Flags (C, E, U, A, P, R, S, F):</strong>
                                <ul>
                                    <li><strong>A (ACK):</strong> Field ACK valid.</li>
                                    <li><strong>S (SYN):</strong> Setup koneksi.</li>
                                    <li><strong>F (FIN):</strong> Tutup koneksi.</li>
                                </ul>
                            </li>
                            <li><strong>Receive Window (16-bit):</strong> Untuk <em>Flow Control</em> (jumlah byte yang
                                bisa diterima).</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_header_indo.jpg" alt="Struktur Segmen TCP">
                        <div>Format Header TCP
                            (Berdasarkan RFC 793)</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>TCP RTT dan Timeout</h3>
                <div>
                    <div>
                        <div>Estimasi RTT &amp; Timeout</div>
                        <div>
                            <ul>
                                <li>TCP mengatur interval <em>Timeout</em> secara dinamis karena RTT jaringan selalu
                                    berubah.</li>
                                <li>Menggunakan <code>EstimatedRTT</code> (rata-rata berbobot dari sampel RTT) dan
                                    <code>DevRTT</code> (margin keamanan/fluktuasi).
                                </li>
                                <li><strong>TimeoutInterval</strong> = EstimatedRTT + 4 * DevRTT.</li>
                                <li>Jika terjadi timeout, paket dikirim ulang, dan interval timeout
                                    <strong>digandakan</strong>.
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_rtt.jpg" alt="Grafik TCP RTT dan Timeout">
                        <div>Grafik Dinamika SampleRTT,
                            EstimatedRTT, dan Timeout Interval.</div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Fast Retransmit</h3>
                <div>

                    <div>
                        <div>Fast Retransmit</div>
                        <div>
                            <ul>
                                <li>Menunggu timeout seringkali terlalu lama.</li>
                                <li>Jika pengirim menerima <strong>3 Duplicate ACKs</strong> untuk data yang sama, ini
                                    menandakan paket berikutnya hilang.</li>
                                <li>Pengirim akan langsung melakukan <strong>Fast Retransmit</strong> (mengirim ulang
                                    paket tersebut) tanpa menunggu timer timeout habis.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/fast_retransmit.jpg" alt="Ilustrasi Fast Retransmit">
                        <div>Ilustrasi Fast Retransmit:
                            Mengirim ulang sebelum Timeout berdasarkan 3 Duplicate ACKs.</div>
                    </div>
                </div>

            </section>


            
            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s7$qa$, $qa$jarkom-p5$qa$, $qa$6. Manajemen Koneksi TCP$qa$, $qa$</section>

            <section>
                <h3>Manajemen Koneksi (Karakteristik TCP)</h3>
                <div>
                    <ul>
                        <li><strong>Point-to-point:</strong> Satu pengirim, satu penerima.</li>
                        <li><strong>Reliable, in-order byte stream:</strong> Data dijamin sampai dengan utuh dan
                            berurutan.</li>
                        <li><strong>Connection-oriented:</strong> Wajib melakukan handshaking sebelum bertukar data.
                        </li>
                        <li><strong>Full duplex data:</strong> Aliran data dua arah (bi-directional) dalam koneksi yang
                            sama.</li>
                    </ul>
                    <div>
                        Sebelum mempertukarkan data aplikasi, pengirim dan penerima harus saling menyapa (handshake)
                        untuk menyepakati parameter koneksi dan inisialisasi urutan (Sequence Number).
                    </div>
                </div>
            </section>

            <section>
                <h3>Animasi: TCP 3-Way Handshake</h3>

                <div>
                    <div>
                        <i></i>
                        <div>Client</div>
                        <div></div>
                    </div>

                    <div>1. SYN (seq=x)</div>
                    <div>2. SYN-ACK (seq=y, ack=x+1)</div>
                    <div>3. ACK (ack=y+1)</div>

                    <div>
                        <i></i>
                        <div>Server</div>
                        <div>
                        </div>
                    </div>
                </div>

                <div>
                    <strong>Proses:</strong> 1) Klien kirim SYN (meminta koneksi). 2) Server membalas SYN-ACK (setuju &
                    minta balik). 3) Klien membalas ACK (konfirmasi akhir). Koneksi terbentuk!
                </div>
            </section>

            <section>
                <h3>Menutup Koneksi TCP (Teardown)</h3>
                <div>
                    <p>Berbeda dengan saat membuka koneksi yang hanya butuh 3 langkah, menutup koneksi TCP butuh
                        <strong>4 langkah</strong> karena sifatnya yang asimetris.
                    </p>
                    <ul>
                        <li>Koneksi TCP adalah dua jalur komunikasi satu arah yang digabung (Full Duplex).</li>
                        <li>Setiap pihak harus menutup jalurnya masing-masing menggunakan bendera <strong>FIN</strong>
                            (Finish).</li>
                        <li>Ketika Klien mengirim FIN, ia tidak bisa lagi mengirim data, tapi <strong>masih bisa
                                menerima data</strong> dari Server sampai Server juga mengirim FIN.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Animasi: TCP 4-Way Teardown</h3>

                <div>
                    <div>
                        <i></i>
                        <div>Client</div>
                        <div>FIN_WAIT / CLOSED</div>
                    </div>

                    <div>1. FIN (Saya selesai kirim)</div>
                    <div>2. ACK (Oke, saya terima FIN)</div>
                    <div>3. FIN (Saya juga selesai)</div>
                    <div>4. ACK (Oke, Bye!)</div>

                    <div>
                        <i></i>
                        <div>Server</div>
                        <div>CLOSE_WAIT / CLOSED</div>
                    </div>
                </div>

                <div>
                    <strong>Catatan:</strong> Terkadang langkah 2 dan 3 digabung menjadi satu paket (FIN+ACK) oleh
                    server jika server memang sudah tidak ada data lagi untuk dikirim.
                </div>
            </section>

            
            <section>$qa$, 7) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s8$qa$, $qa$jarkom-p5$qa$, $qa$7. Flow Control (Kendali Aliran)$qa$, $qa$</section>

            <section>
                <h3>Flow Control</h3>
                <h4>Melindungi Penerima</h4>
                <div>
                    <div>
                        <p><strong>Masalah:</strong> Bagaimana jika aplikasi di sisi penerima sangat lambat membaca data
                            dari buffer TCP, sementara pengirim menembakkan data dengan sangat cepat?</p>
                        <p><i></i> Akibat: Buffer overflow di penerima (data
                            hilang / tertolak).</p>

                        <p>Solusi TCP (Flow Control):</p>
                        <ul>
                            <li>Penerima secara eksplisit memberitahu pengirim <strong>berapa banyak ruang kosong yang
                                    tersisa</strong> di buffernya.</li>
                            <li>Nilai ini ditaruh di field <strong>rwnd (Receive Window)</strong> pada header TCP setiap
                                kali penerima membalas dengan ACK.</li>
                            <li>Pengirim mematuhi aturan: jumlah data yang sedang melayang (un-ACKed data) <em>tidak
                                    boleh
                                    melebihi</em> nilai <code>rwnd</code> saat ini.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/flow_control_indo.jpg" alt="Ilustrasi TCP Flow Control">
                        <div>Penerima mengatur debit
                            aliran data pengirim melalui parameter rwnd.</div>
                    </div>
                </div>

            </section>

            <section>
                <h3>Ilustrasi Receive Window (rwnd)</h3>
                <div>
                    <img src="https://informatika-itera.github.io/jarkom/img/week5/rwnd_buffer_indo.jpg" alt="Ilustrasi TCP Receive Buffer">
                    <div>
                        <strong>Catatan:</strong> Jika aplikasi (di penerima) lambat dalam membaca data dari sistem,
                        maka porsi blok <strong>"Data Belum Dibaca Aplikasi"</strong> akan semakin membesar, yang
                        artinya <strong>"Ruang Kosong (rwnd)"</strong> semakin menyusut. Pengirim akan mengetahui hal
                        ini dari balasan ACK dan akan langsung memperlambat pengiriman secara otomatis untuk mencegah
                        <em>buffer overflow</em>.
                    </div>
                </div>
            </section>

            
            <section>$qa$, 8) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s9$qa$, $qa$jarkom-p5$qa$, $qa$8. TCP Congestion Control$qa$, $qa$</section>

            <section>
                <h3>Apa itu Congestion? (Kemacetan Jaringan)</h3>
                <div>
                    <div>
                        <p><strong>Definisi:</strong> Terlalu banyak sumber yang mengirim terlalu banyak data, terlalu
                            cepat, sehingga <strong>jaringan (router di tengah jalan)</strong> tidak sanggup
                            menanganinya.
                        </p>
                        <p>Ciri-ciri Kemacetan Jaringan:</p>
                        <ul>
                            <li><strong>Delay Ekstrem:</strong> Paket mengantre lama di dalam buffer router.</li>
                            <li><strong>Packet Loss:</strong> Buffer router penuh, sehingga router terpaksa membuang
                                paket yang baru datang (overflow).</li>
                        </ul>
                        <div>
                            ⚠️ <strong>Perbedaan Penting:</strong>
                            <br><em>Flow Control</em> = Mencegah buffer <strong>Penerima</strong> penuh.
                            <br><em>Congestion Control</em> = Mencegah buffer <strong>Router Jaringan</strong> penuh.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/network_congestion.jpg" alt="Ilustrasi Kemacetan Jaringan">
                        <div>Buffer router yang penuh
                            memicu pembuangan paket (Packet Loss).</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Animasi: Terjadinya Kemacetan (Congestion)</h3>

                <div>
                    
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>
                    <div></div>

                    
                    <div>
                        <i></i>
                        <div></div>
                    </div>

                    <div>
                        Buffer Router Penuh → Paket Berikutnya Dibuang (Drop)
                    </div>
                </div>

                <div>
                    Biaya dari kemacetan: Paket yang sudah berhasil melewati setengah jalan internet terbuang percuma,
                    menguras kapasitas jaringan secara global. Pengirim harus melakukan retransmisi.
                </div>
            </section>

            <section>
                <h3>TCP Congestion Control (AIMD)</h3>
                <div>
                    <p>TCP melakukan kontrol kemacetan secara <strong>End-to-End</strong>. TCP tidak bisa bertanya ke
                        router, jadi ia menebak kemacetan dari adanya <em>packet loss</em>.</p>
                    <p>Algoritma AIMD (Additive Increase,
                        Multiplicative Decrease):</p>
                    <ul>
                        <li><strong>Additive Increase (Probe Bandwidth):</strong> Selama tidak ada loss, perlahan-lahan
                            tingkatkan kecepatan transmisi (+1 MSS setiap RTT) untuk <em>meraba-raba</em> batas
                            bandwidth maksimal.</li>
                        <li><strong>Multiplicative Decrease (Rem Darurat):</strong> Jika terjadi packet loss, segera
                            <strong>potong kecepatan transmisi menjadi setengahnya</strong>.
                        </li>
                    </ul>
                </div>
            </section>
            <section>
                <h3>Algoritma AIMD (1)</h3>
                <div>
                    <div>
                        <p><strong>Additive Increase (Probe Bandwidth):</strong> Selama tidak
                            ada loss,
                            perlahan-lahan tingkatkan kecepatan transmisi (+1 MSS setiap RTT) untuk <em>meraba-raba</em>
                            batas
                            bandwidth maksimal.</p>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/aimd_1_indo.jpg" alt="Additive Increase">
                        <div>Fase Additive Increase (+1
                            MSS per RTT)</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Algoritma AIMD (2)</h3>
                <div>
                    <div>
                        <p><strong>Multiplicative Decrease (Rem Darurat):</strong> Jika terjadi
                            packet loss, segera <strong>potong kecepatan transmisi menjadi setengahnya</strong>.</p>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/aimd_2_indo.jpg" alt="Multiplicative Decrease">
                        <div>Fase Multiplicative
                            Decrease (Potong Setengah)</div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Animasi: Pola Gigi Gergaji (Sawtooth)</h3>

                <div>
                    <svg>
                        
                        <line>
                        <line>
                        <text>Kecepatan</text>
                        <text>Waktu</text>

                        
                        <line>
                        <text>Batas Kemacetan
                            (Loss)</text>

                        
                        <path>

                        
                        <text>Additive Increase</text>
                        <text>Drop (1/2)</text>
                    </svg>
                </div>

                <div>
                    Perilaku ini menghasilkan pola "Gigi Gergaji" yang khas pada grafik throughput TCP. TCP terus
                    "menggoda" batas maksimal jaringan secara berkelanjutan.
                </div>
            </section>

            <section>
                <h3>Fase TCP</h3>
                <h4>Congestion Control (1)</h4>
                <div>
                    <div>
                        <div>1. Slow Start</div>
                        <div>
                            <ul>
                                <li>Saat koneksi baru dimulai, <code>cwnd</code> (Congestion Window) diset kecil (misal
                                    1 MSS).</li>
                                <li>Namun, TCP ingin menemukan kapasitas maksimum secara cepat.</li>
                                <li>Oleh karena itu, <code>cwnd</code> ditingkatkan secara <strong>eksponensial</strong>
                                    (digandakan setiap RTT) dengan menambahkan 1 MSS untuk setiap ACK yang diterima.
                                </li>
                                <li>Fase ini berlangsung hingga <code>cwnd</code> mencapai threshold (ssthresh) atau
                                    terjadi <em>loss</em>.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_slow_start.jpg" alt="Fase Slow Start">
                        <div>Peningkatan eksponensial
                            menuju batas Threshold</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Fase TCP</h3>
                <h4>Congestion Control (2)</h4>
                <div>
                    <div>
                        <div>2. Congestion Avoidance</div>
                        <div>
                            <ul>
                                <li>Ketika <code>cwnd</code> melewati threshold, peningkatan menjadi linier
                                    (<strong>Additive Increase</strong>).</li>
                                <li>Tujuannya untuk "meraba" sisa bandwidth dengan hati-hati.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_congestion_avoidance.jpg" alt="Fase Congestion Avoidance">
                        <div>Peningkatan linier setelah
                            melewati Threshold</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Fase TCP</h3>
                <h4>Congestion Control (3)</h4>
                <div>
                    <div>
                        <div>3. Fast Recovery</div>
                        <div>
                            <ul>
                                <li>Jika terjadi loss akibat <strong>3 Duplicate ACKs</strong>, <code>cwnd</code>
                                    dipotong menjadi setengahnya, lalu masuk ke fase Fast Recovery.</li>
                                <li>Jika loss karena <strong>Timeout</strong>, <code>cwnd</code> di-reset kembali ke 1
                                    MSS (kembali ke Slow Start).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_fast_recovery.jpg" alt="Fase Fast Recovery vs Timeout">
                        <div>Perbandingan penanganan
                            loss: 3 Dup ACKs vs Timeout</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Varian Congestion Control &amp; Fairness (1)</h3>
                <div>
                    <div>
                        <div>TCP CUBIC</div>
                        <div>
                            <ul>
                                <li>Varian TCP default pada Linux/Android modern.</li>
                                <li>AIMD tradisional kurang agresif di jaringan berkecepatan sangat tinggi.</li>
                                <li><strong>Ide CUBIC:</strong> Menggunakan fungsi kubik (pangkat 3) untuk memulihkan
                                    <code>cwnd</code> setelah loss.
                                </li>
                                <li>Meningkatkan ukuran window dengan sangat cepat di awal, lalu melambat ketika
                                    mendekati ukuran maksimum sebelum loss sebelumnya (Wmax).</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_cubic.jpg" alt="Grafik TCP CUBIC vs Standard TCP">
                        <div>Fungsi Kubik TCP
                            mempercepat pemulihan menuju Wmax</div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Varian Congestion Control &amp; Fairness (2)</h3>
                <div>
                    <div>
                        <div>TCP Fairness (Keadilan)</div>
                        <div>
                            <ul>
                                <li>Jika ada K koneksi TCP yang melewati sebuah bottleneck link berkapasitas R, apakah
                                    masing-masing akan mendapat bandwidth sebesar R/K?</li>
                                <li><strong>Ya, TCP pada dasarnya "Fair" (Adil).</strong> Mekanisme AIMD secara
                                    matematis memaksa aliran TCP yang bersaing untuk pada akhirnya berbagi bandwidth
                                    secara seimbang.</li>
                                <li>Namun, koneksi dengan RTT yang lebih kecil (jarak lebih dekat) biasanya bisa
                                    meningkatkan <code>cwnd</code> lebih cepat, sehingga mengambil porsi lebih banyak.
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/tcp_fairness.jpg" alt="Ilustrasi Keadilan TCP">
                        <div>Ilustrasi pembagian
                            Bandwidth (R) secara adil untuk 3 koneksi</div>
                    </div>
                </div>
            </section>


            
            <section>$qa$, 9) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p5-s10$qa$, $qa$jarkom-p5$qa$, $qa$9. Evolusi Transport Layer (QUIC)$qa$, $qa$</section>

            <section>
                <h3>QUIC: Quick UDP Internet Connections</h3>
                <div>
                    <div>
                        <ul>
                            <li>Dirancang oleh Google, kini menjadi fondasi <strong>HTTP/3</strong>.</li>
                            <li><strong>Menggunakan UDP</strong> di bawahnya, tetapi mengimplementasikan keandalan
                                (RDT), congestion control, dan keamanan (TLS) di level aplikasi/QUIC itu sendiri.</li>
                            <li><strong>Kelebihan Utama:</strong>
                                <ul>
                                    <li><strong>Fast Connection Setup:</strong> Menggabungkan handshake transport dan
                                        kriptografi (TLS) menjadi 1 RTT (atau bahkan 0 RTT!). TCP+TLS biasanya butuh 2-3
                                        RTT.</li>
                                    <li><strong>No Head-of-Line Blocking:</strong> Memiliki konsep "Streams" independen.
                                        Jika satu paket hilang di Stream A, Stream B tetap bisa diproses tanpa terhenti.
                                    </li>
                                </ul>
                            </li>
                            <li>Masa depan protokol web yang lebih cepat dan efisien!</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week5/quic_vs_tcp.jpg" alt="Perbandingan Koneksi TCP+TLS vs QUIC">
                        <div>QUIC (1 RTT) vs TCP+TLS (3
                            RTT)</div>
                    </div>
                </div>
            </section>



            
            <section>
                <h3>Rangkuman Pertemuan 5</h3>
                <div>
                    <div>
                        <p>Transport Layer, UDP &amp; RDT</p>
                        <ul>
                            <li><strong>Transport Layer:</strong> Komunikasi antar proses (Process-to-Process)
                                menggunakan Port Numbers. Melakukan proses Multiplexing/Demultiplexing.</li>
                            <li><strong>UDP:</strong> Protokol connectionless, unreliable, namun cepat tanpa overhead.
                                Sangat ideal untuk layanan streaming dan DNS.</li>
                            <li><strong>RDT &amp; Pipelining:</strong> Mekanisme keandalan transfer data menggunakan
                                Checksum, ACK/NACK, Sequence Number, dan Timer.</li>
                            <li><strong>Pipelining (GBN &amp; SR):</strong> Protokol yang mengizinkan pengiriman banyak
                                paket sekaligus tanpa menunggu ACK untuk memaksimalkan utilitas bandwidth.</li>
                        </ul>
                    </div>
                    <div>
                        <p>TCP, Congestion Control &amp; QUIC</p>
                        <ul>
                            <li><strong>TCP:</strong> Protokol connection-oriented, andal (reliable), dan berurutan
                                (in-order byte-stream).</li>
                            <li><strong>Manajemen Koneksi:</strong> 3-Way Handshake (setup) &amp; 4-Way Teardown
                                (teardown).</li>
                            <li><strong>Flow Control:</strong> Mekanisme untuk melindungi buffer <em>penerima</em> agar
                                tidak kewalahan (menggunakan <code>rwnd</code>).</li>
                            <li><strong>Congestion Control:</strong> Melindungi antrean <em>router</em> jaringan agar
                                tidak macet menggunakan algoritma AIMD (Slow Start, Congestion Avoidance, Fast
                                Recovery).</li>
                            <li><strong>QUIC:</strong> Evolusi Transport Layer untuk HTTP/3 yang dibangun di atas UDP
                                guna menghilangkan efek <em>Head-of-Line Blocking</em>.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <div>
                    <h3>📝 Tugas Individu — Pertemuan 5</h3>
                    <p>Dikerjakan analitik, ditulis tangan di
                        kertas folio, difoto, dikirim ke e-learning.</p>

                    <div>
                        <p><span>1.</span> <strong>[Analogi Kurir Pos]</strong>
                            Gunakan Analogi lapisan Transport sebagai "Petugas Pos" yang menyortir surat
                            (port/soket).
                            Jika Petugas Pos mempekerjakan dua kurir pembantu: "Si Cepat-tapi-Ceroboh" dan "Si
                            Lambat-tapi-Pasti", petakan karakteristik kedua kurir tersebut ke dalam mekanisme
                            <em>multiplexing</em>, pengurutan, dan keandalan (reliability) milik protokol
                            <strong>UDP</strong> dan <strong>TCP</strong>! Jelaskan mengapa keduanya tetap dibutuhkan!
                        </p>
                    </div>

                    <div>
                        <p><span>2.</span> <strong>[Studi Kasus Grafis TCP]</strong> Gambarkan secara
                            mandiri di kertas Anda grafik gigi gergaji (AIMD) TCP dengan skenario berikut: Koneksi
                            dimulai dengan <code>ssthresh</code> = 8 MSS. Siklus ke-1 hingga 4 berjalan normal. Pada
                            awal Siklus ke-5, terjadi <em>packet loss</em> akibat <strong>3 Duplicate ACKs</strong>.
                            Koneksi pulih dan berjalan normal dari Siklus ke-6 hingga ke-8. <strong>Berapakah nilai
                                pasti <code>cwnd</code> (Congestion Window) pada Siklus ke-4, Siklus ke-5 (saat potong),
                                dan Siklus ke-8?</strong> (Petunjuk: Pahami perbedaan Slow Start vs Congestion
                            Avoidance).</p>
                    </div>

                    <div>
                        <p><span>3.</span> <strong>[Analisis QUIC &amp; SIAKAD]</strong> Protokol QUIC
                            (HTTP/3) berevolusi di atas UDP untuk memecahkan masalah <em>Head-of-Line Blocking</em>
                            milik TCP. Jika kelak SIAKAD ITERA dimigrasikan ke HTTP/3, jelaskan sebuah skenario spesifik
                            saat masa KRS-an (jaringan sibuk) bagaimana arsitektur QUIC mencegah <em>packet loss</em>
                            pada satu <em>request</em> (misal: <em>request</em> gambar aset web) memblokir antrean
                            <em>request</em> krusial lainnya (misal: <em>request</em> simpan KRS)!
                        </p>
                    </div>
                </div>
            </section>

            <section>$qa$, 10) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-c1$qa$, $qa$jarkom-p5$qa$, $qa$checkpoint$qa$, $qa$Perbedaan utama TCP dibanding UDP adalah...$qa$, $qa$["TCP tidak memakai port", "TCP andal dan berorientasi koneksi, UDP cepat tanpa jaminan", "UDP selalu lebih lambat", "TCP hanya untuk video"]$qa$::jsonb, 1, $qa$TCP menjamin data tiba utuh dan urut; UDP mengutamakan kecepatan.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-c2$qa$, $qa$jarkom-p5$qa$, $qa$checkpoint$qa$, $qa$Proses membangun koneksi TCP dikenal sebagai...$qa$, $qa$["Two-way handshake", "Four-way handshake", "Three-way handshake", "Fast open saja"]$qa$::jsonb, 2, $qa$TCP memakai SYN, SYN-ACK, ACK: three-way handshake.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-c3$qa$, $qa$jarkom-p5$qa$, $qa$checkpoint$qa$, $qa$Congestion control pada TCP berfungsi...$qa$, $qa$["Menambah bandwidth fisik kabel", "Menyesuaikan laju kirim agar jaringan tidak kelebihan beban", "Mengenkripsi paket", "Mengatur alamat IP"]$qa$::jsonb, 1, $qa$Congestion control menurunkan laju saat jaringan padat agar tidak kolaps.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-b1$qa$, $qa$jarkom-p5$qa$, $qa$battle$qa$, $qa$Aplikasi manakah yang paling tepat memakai UDP?$qa$, $qa$["Transfer file penting antar bank", "Game online FPS yang butuh respons instan", "Pengiriman email", "Browsing katalog produk"]$qa$::jsonb, 1, $qa$UDP cepat tanpa handshake/retransmisi; kehilangan satu paket pergerakan jauh lebih baik daripada lag akibat retransmisi TCP.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-b2$qa$, $qa$jarkom-p5$qa$, $qa$battle$qa$, $qa$Urutan yang benar dalam TCP 3-way handshake adalah...$qa$, $qa$["SYN lalu ACK lalu SYN-ACK", "SYN lalu SYN-ACK lalu ACK", "ACK lalu SYN lalu SYN-ACK", "FIN lalu ACK lalu SYN"]$qa$::jsonb, 1, $qa$Klien kirim SYN, server balas SYN-ACK, klien konfirmasi dengan ACK — barulah koneksi terbentuk.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-b3$qa$, $qa$jarkom-p5$qa$, $qa$battle$qa$, $qa$Pengirim TCP menerima 3 duplicate ACK untuk data yang sama. Tindakan yang dilakukan...$qa$, $qa$["Menunggu timeout lalu mengirim ulang semua data", "Fast retransmit: langsung mengirim ulang paket yang hilang tanpa menunggu timeout", "Menutup koneksi dan handshake ulang", "Mengurangi rwnd menjadi nol"]$qa$::jsonb, 1, $qa$3 duplicate ACK menandakan paket berikutnya hilang; fast retransmit menghemat waktu tunggu timer.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-b4$qa$, $qa$jarkom-p5$qa$, $qa$battle$qa$, $qa$Perbedaan flow control dan congestion control pada TCP adalah...$qa$, $qa$["Keduanya melindungi buffer router", "Flow control melindungi buffer penerima via rwnd; congestion control melindungi buffer router via AIMD", "Flow control hanya ada di UDP", "Congestion control mengatur kecepatan aplikasi"]$qa$::jsonb, 1, $qa$Flow control mencegah pengirim membanjiri penerima yang lambat; congestion control mencegah membanjiri jaringan.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p5-b5$qa$, $qa$jarkom-p5$qa$, $qa$battle$qa$, $qa$Pada Go-Back-N, ketika paket nomor 5 hilang (timeout), pengirim akan...$qa$, $qa$["Mengirim ulang hanya paket nomor 5", "Mengirim ulang paket 5 dan semua paket setelahnya", "Menunggu ACK kumulatif berikutnya tanpa aksi", "Mengurangi ukuran paket menjadi setengah"]$qa$::jsonb, 1, $qa$GBN memakai cumulative ACK sehingga seluruh window setelah paket hilang dikirim ulang — boros dibanding Selective Repeat.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
