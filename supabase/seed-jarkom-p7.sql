insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p7$qa$, $qa$jarkom$qa$, $qa$Network Layer: Control Plane$qa$, $qa$<h3>Network Layer: Control Plane</h3>
<p><strong>Control plane</strong> adalah bagian lapisan network yang menentukan jalur yang akan ditempuh paket: logika routing. Berbeda dari data plane yang meneruskan paket dari input ke output router, control plane bekerja pada skala jaringan yang lebih luas dan waktunya lebih lambat.</p>
<ul>
<li><strong>Algoritma routing</strong>: link-state (semua router tahu peta topologi lengkap, memakai Dijkstra) versus distance-vector (router hanya tahu tetangga, bertukar tabel jarak).</li>
<li><strong>OSPF</strong>: protokol link-state di dalam satu AS, memakai flooding LSA dan area hierarkis.</li>
<li><strong>ICMP</strong>: protokol bantuan untuk pelaporan error dan diagnostik, dipakai ping dan traceroute.</li>
<li><strong>Manajemen jaringan</strong>: SNMP klasik, serta pendekatan modern NETCONF dengan model data YANG.</li>
</ul>
<p>Baca penjelasan bertahapnya untuk memahami cara Dijkstra memilih jalur dan bagaimana router-router menyepakati rute yang sama.</p>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan07.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 7) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p7-s1$qa$, $qa$jarkom-p7$qa$, $qa$Network Layer: Control Plane$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>

            
            <section>
                <div>
                    
                    <h3>Pertemuan 7</h3>
                </div>
                <p>Referensi Utama: Kurose &amp; Ross — <em>Computer Networking (8th Ed)</em></p>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
                <aside>Selamat datang di Pertemuan 7. Hari ini kita akan membahas Network Layer bagian
                    Control Plane: bagaimana rute perjalanan paket ditentukan di internet.</aside>
            </section>

            
            <section>
                <h3>Outline Materi</h3>
                <div>
                    <div>
                        <p>
                            Bagian 1: Pendahuluan Control Plane</p>
                        <ul>
                            <li>Dua Pendekatan Control Plane</li>
                            <li>Per-router (Tradisional) vs SDN</li>
                        </ul>

                        <p>Bagian 2: Algoritma
                            Routing</p>
                        <ul>
                            <li>Konsep Graph Abstraction</li>
                            <li>Link State (Dijkstra)</li>
                            <li>Distance Vector (Bellman-Ford)</li>
                        </ul>
                    </div>
                    <div>
                        <p>Bagian 3: Protokol
                            Routing di
                            Internet</p>
                        <ul>
                            <li>Intra-AS vs Inter-AS</li>
                            <li>OSPF (Intra-ISP) &amp; BGP (Inter-ISP)</li>
                        </ul>

                        <p>Bagian 4: Protokol
                            Bantuan &amp;
                            Manajemen</p>
                        <ul>
                            <li>ICMP (Ping &amp; Traceroute)</li>
                            <li>Network Management (SNMP)</li>
                            <li>NETCONF &amp; YANG</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p7-s2$qa$, $qa$jarkom-p7$qa$, $qa$1. Pendahuluan Control Plane$qa$, $qa$</section>

            <section>
                <h3>Fungsi Network Layer (Data vs Control)</h3>
                <div>
                    <p>Di Pertemuan 6, kita belajar tentang <strong>Data Plane</strong> (pengalamatan IP dan
                        subnetting). Sekarang kita masuk ke <strong>Control Plane</strong>.</p>
                    <div>
                        <div>
                            <strong>Data Plane (Forwarding):</strong><br>
                            Mekanisme lokal per-router. Memindahkan paket dari <em>input link</em> router ke <em>output
                                link</em> yang tepat berdasarkan <em>Forwarding Table</em>.
                        </div>
                        <div>
                            <strong>Control Plane (Routing):</strong><br>
                            Logika jaringan secara keseluruhan (network-wide). Menentukan <em>rute/path</em> end-to-end
                            yang akan diambil paket dari sumber ke tujuan. Control Plane lah yang membuat <em>Forwarding
                                Table</em>.
                        </div>
                    </div>
                    <aside>Ingatkan kembali analogi: Forwarding adalah tindakan fisik belok kiri/kanan di
                        persimpangan jalan, sedangkan Routing adalah perencanaan peta rute perjalanan dari kota A ke
                        kota B.</aside>
                </div>
            </section>

            <section>
                <h3>Dua Pendekatan Control Plane</h3>
                <div>
                    <p>Bagaimana Control Plane diimplementasikan? Ada dua pendekatan utama di internet saat ini:</p>
                    <ol>
                        <li>
                            <strong>Kontrol Tradisional (Per-router):</strong> Setiap router memiliki agen routing
                            masing-masing (berjalan sendiri-sendiri) yang saling bertukar informasi. Algoritma (seperti
                            OSPF/BGP) dihitung <em>di dalam setiap router</em>.
                        </li>
                        <li>
                            <strong>Software-Defined Networking (SDN):</strong> Logika kontrol dipisahkan dari router
                            fisik. Sebuah "otak" terpusat berupa <em>Remote Controller</em> (server) menghitung rute dan
                            meng-install <em>Forwarding Table</em> ke setiap <em>switches</em>.
                        </li>
                    </ol>
                    <aside>Per-router adalah model warisan internet sejak awal. SDN adalah inovasi modern
                        di pusat data dan jaringan ISP besar saat ini.</aside>
                </div>
            </section>

            <section>
                <h3>Dua Pendekatan Control Plane (Bagian 2)</h3>
                <div>
                    <p>
                        <i></i> Fokus: Kontrol Tradisional (Per-Router Control)
                    </p>
                    <p>
                        Pada pendekatan tradisional, fungsi <strong>Control Plane</strong> dan <strong>Data
                            Plane</strong> menyatu erat di dalam setiap kotak router fisik (arsitektur <em>vertically
                            integrated / monolitik</em>).
                    </p>

                    
                    <div>
                        
                        <div>
                            <div><i></i>
                                Router Fisik A</div>
                            <div>
                                <strong>Control Plane:</strong> Algoritma Routing (CPU)
                            </div>
                            <div>⬇ <em>instal rute lokal</em></div>
                            <div>
                                <strong>Data Plane:</strong> Forwarding Table (ASIC)
                            </div>
                        </div>

                        
                        <div>
                            <i></i>
                            Pesan Protokol Routing<br><span>(OSPF / BGP Updates)</span>
                        </div>

                        
                        <div>
                            <div><i></i>
                                Router Fisik B</div>
                            <div>
                                <strong>Control Plane:</strong> Algoritma Routing (CPU)
                            </div>
                            <div>⬇ <em>instal rute lokal</em></div>
                            <div>
                                <strong>Data Plane:</strong> Forwarding Table (ASIC)
                            </div>
                        </div>
                    </div>


                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>"Setiap router berpikir sendiri (otak otonom) dan
                            meneruskan paketnya sendiri berdasarkan hasil kalkulasi lokal."</em>
                    </div>
                    <aside>Jelaskan bahwa pendekatan per-router adalah pondasi internet tradisional selama
                        beberapa dekade. Analogi: seperti pengemudi mobil di jalan raya yang masing-masing membawa peta,
                        saling berkomunikasi via radio dengan pengemudi lain, lalu memutuskan sendiri ke mana harus
                        berbelok di setiap persimpangan. Hubungan control plane dan data plane terikat erat (vertically
                        integrated) di sasis perangkat vendor yang sama.</aside>
                </div>
            </section>
            <section>
                <h3>Dua Pendekatan Control Plane (Bagian 3)</h3>
                <div>


                    
                    <div>
                        <div>
                            <div>Mekanisme Kerja
                                Terdistribusi</div>
                            <div>
                                <ul>
                                    <li><strong>Komponen Routing
                                            Mandiri:</strong> Setiap router menjalankan daemon routing (OSPF, RIP, BGP)
                                        di prosesor lokal tanpa server sentral.</li>
                                    <li><strong>Pertukaran
                                            Peer-to-Peer:</strong> Router bertukar pesan update/topologi secara berkala
                                        dengan router tetangga.</li>
                                    <li><strong>Kalkulasi Lokal:</strong> Mengeksekusi algoritma
                                        (Dijkstra/Bellman-Ford) untuk langsung mengisi <em>Forwarding Table</em> lokal.
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div>
                            <div>Kelebihan
                                &amp; Keterbatasan</div>
                            <div>
                                <ul>
                                    <li><strong>Kelebihan
                                            (Fault-Tolerant):</strong> Terdesentralisasi penuh — tidak ada <em>single
                                            point of failure</em>. Jaringan otomatis konvergen bila link putus.</li>
                                    <li><strong>Keterbatasan (Per-Box
                                            Config):</strong> Konfigurasi manual satu per satu via CLI/SSH, rawan
                                        <em>human error</em> dan lambat diskalakan.
                                    </li>
                                    <li><strong>Vendor Lock-in:</strong> Inovasi lambat karena software
                                        dan hardware terikat erat pada vendor proprietary (Cisco, Juniper, dll.).</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>"Setiap router berpikir sendiri (otak otonom) dan
                            meneruskan paketnya sendiri berdasarkan hasil kalkulasi lokal."</em>
                    </div>
                    <aside>Jelaskan bahwa pendekatan per-router adalah pondasi internet tradisional selama
                        beberapa dekade. Analogi: seperti pengemudi mobil di jalan raya yang masing-masing membawa peta,
                        saling berkomunikasi via radio dengan pengemudi lain, lalu memutuskan sendiri ke mana harus
                        berbelok di setiap persimpangan. Hubungan control plane dan data plane terikat erat (vertically
                        integrated) di sasis perangkat vendor yang sama.</aside>
                </div>
            </section>


            <section>
                <h3>Dua Pendekatan Control Plane (Bagian 4)</h3>
                <div>
                    <p>
                        <i></i> Fokus: Software-Defined Networking (SDN)
                    </p>
                    <p>
                        SDN merevolusi arsitektur jaringan dengan <strong>memisahkan (decoupling)</strong> logika
                        kendali (Control Plane) dari perangkat keras penerus paket (Data Plane).
                    </p>

                    <div>
                        <div>
                            <div>Mekanisme
                                Kerja SDN</div>
                            <div>
                                <ul>
                                    <li><strong>Otak Terpusat (SDN
                                            Controller):</strong> Server terpusat memiliki pandangan global seluruh
                                        topologi dan menghitung semua rute.</li>
                                    <li><strong>Perangkat Penerus (Dumb
                                            Switches):</strong> Switch fisik hanya bertugas memindahkan paket data
                                        sesuai instruksi controller.</li>
                                    <li><strong>Instalasi Jarak Jauh:</strong> Controller memasang
                                        <em>flow/forwarding table</em> ke switch via protokol standar (misal OpenFlow).
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div>
                            <div>Kelebihan
                                &amp; Tantangan</div>
                            <div>
                                <ul>
                                    <li><strong>Kelebihan
                                            (Programmable):</strong> Jaringan fleksibel, otomatis, dan dapat dikontrol
                                        langsung dengan script/API (Python).</li>
                                    <li><strong>Manajemen
                                            Terpusat:</strong> Kebijakan routing, security, dan QoS global dapat diubah
                                        seketika dari satu titik kontrol.</li>
                                    <li><strong>Tantangan (Resiliensi):</strong> Controller harus
                                        dibuat redundan (cluster) agar tidak menjadi <em>single point of failure</em>.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div>
                        ⚡ <strong>Inti Konsep:</strong> <em>"Otak dipusatkan pada server Controller (Software),
                            sementara switch fisik hanya menjadi pelaksana penerus paket (Hardware)."</em>
                    </div>
                    <aside>SDN menjadi standar di arsitektur data center modern (seperti Google, AWS,
                        Microsoft) karena memungkinkan otomatisasi ribuan server secara dinamis.</aside>
                </div>
            </section>

            <section>
                <h3>Ilustrasi: Per-Router vs SDN</h3>
                <div>
                    
                    <div>
                        <strong>
                            <i></i> Kontrol Tradisional (Per-Router)
                        </strong>
                        <img src="https://informatika-itera.github.io/jarkom/img/week7/control_plane_per_router.jpg" alt="Ilustrasi Arsitektur Control Plane Per-Router">
                        <div>
                            <ul>
                                <li><strong>Arsitektur Monolitik:</strong> Control Plane (Algoritma OSPF/BGP di CPU) dan
                                    Data Plane (FIB) menyatu di setiap router fisik.</li>
                                <li><strong>Koordinasi Peer-to-Peer:</strong> Router saling bertukar pesan rute dengan
                                    tetangga untuk menghitung jalur terpendek secara mandiri.</li>
                                <li><strong>Karakteristik:</strong> Desentralisasi penuh, toleran terhadap kegagalan,
                                    namun memerlukan konfigurasi manual per-perangkat.</li>
                            </ul>
                        </div>
                    </div>

                    
                    <div>
                        <strong>
                            <i></i> Software-Defined Networking (SDN)
                        </strong>
                        <img src="https://informatika-itera.github.io/jarkom/img/week7/control_plane_sdn.jpg" alt="Ilustrasi Arsitektur Control Plane SDN">
                        <div>
                            <ul>
                                <li><strong>Pemisahan (Decoupling):</strong> Otak kendali dipusatkan pada <em>SDN
                                        Controller</em>, terpisah dari perangkat keras penerus data.</li>
                                <li><strong>Instalasi Jarak Jauh:</strong> Controller menghitung rute global dan
                                    memasang <em>Flow Table</em> via protokol standar (OpenFlow).</li>
                                <li><strong>Karakteristik:</strong> Programmable via API/software, manajemen kebijakan
                                    terpusat, dan switch fisik beroperasi secara sederhana.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <aside>Bandingkan kedua arsitektur secara visual: Pada Per-Router (kiri), setiap router
                    memiliki otak dan otot sendiri serta berkoordinasi peer-to-peer. Pada SDN (kanan), otak dipisahkan
                    dan dipusatkan pada server Controller yang menginstruksikan switch-switch di bawahnya via OpenFlow.
                </aside>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p7-s3$qa$, $qa$jarkom-p7$qa$, $qa$2. Algoritma Routing$qa$, $qa$</section>

            <section>
                <h3>Tujuan &amp; Abstraksi Graf (Graph)</h3>
                <div>
                    <p><strong>Tujuan Routing:</strong> Menemukan jalur (rute) "terbaik" dari sumber ke tujuan.
                        "Terbaik" bisa berarti rute dengan <em>biaya terkecil (least cost)</em>, <em>tercepat</em>, atau
                        <em>paling tidak macet (least congested)</em>.
                    </p>
                    <p>Abstraksi Graf: <code>G = (N, E)</code></p>
                    <ul>
                        <li><strong>N (Nodes):</strong> Kumpulan router (misal:
                            <code>{u, v, w, x, y, z}</code>).
                        </li>
                        <li><strong>E (Edges):</strong> Kumpulan link fisik yang menghubungkan router.
                        </li>
                        <li><strong>c(x, y):</strong> Biaya link (Link Cost) dari router x ke y.
                            Nilainya bisa 1, atau
                            berbasis kapasitas bandwidth, delay, dll. Jika tidak terhubung langsung, biayanya adalah ∞
                            (tak terhingga).</li>
                    </ul>
                    <aside>Dalam teori graf jaringan komputer, setiap router direpresentasikan sebagai
                        simpul (node) dan setiap kabel penghubung sebagai sisi (edge).</aside>
                </div>
            </section>

            <section>
                <h3>Klasifikasi Algoritma Routing</h3>
                <div>
                    <p>Secara umum, algoritma routing dibagi berdasarkan seberapa banyak informasi yang dimiliki oleh
                        sebuah router sebelum menghitung rute:</p>
                    <div>
                        <div>1. Link-State (Algoritma Global)</div>
                        <div>
                            Seluruh router memiliki informasi lengkap tentang topologi dan biaya link seluruh jaringan
                            (Global). Diperoleh dengan cara melakukan <em>"Link State Broadcast"</em> ke semua router.
                            Contoh algoritmanya: <strong>Algoritma Dijkstra</strong>.
                        </div>
                    </div>
                    <div>
                        <div>2. Distance Vector (Algoritma Desentralisasi)</div>
                        <div>
                            Router di awal hanya tahu biaya link ke tetangga terdekatnya. Router kemudian secara
                            iteratif bertukar "vektor jarak" dengan tetangganya hingga rute terbaik ditemukan. Contoh
                            algoritmanya: <strong>Algoritma Bellman-Ford</strong>.
                        </div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Algoritma Link-State: Dijkstra</h3>
                <div>
                    <p><strong>Tujuan:</strong> Menghitung biaya terpendek (Least-cost path) dari satu titik sumber
                        (source) ke <em>semua titik lain</em> di dalam jaringan.</p>
                    <div>
                        <strong>Rumus Iterasi Dijkstra (Relaxation):</strong><br>
                        <code>D(v) = min( D(v), D(w) + c(w,v) )</code>
                        <ul>
                            <li><code>D(v):</code> Estimasi jarak terpendek dari sumber ke node v.</li>
                            <li><code>c(w,v):</code> Biaya fisik dari tetangga w ke v.</li>
                            <li>Intinya: <em>"Apakah biaya lama ke V lebih murah, ATAU lewat W ke V lebih murah?"</em>
                            </li>
                        </ul>
                    </div>
                    <p>Penerapan di Lapisan Network: Digunakan oleh protokol <strong>OSPF</strong>. Setiap router
                        menjalankan Dijkstra secara mandiri setelah menerima gambaran topologi utuh dari router lain,
                        untuk mengisi <em>Forwarding Table</em>-nya.</p>
                </div>
            </section>

            <section>
                <h3>Simulasi Algoritma Dijkstra (Topologi Graf)</h3>
                <div>
                    <p>Misalkan node <strong>u</strong> adalah sumber (source). Kita akan mencari rute terpendek ke
                        seluruh node.</p>
                    <svg>
                        
                        <g>
                            <line>
                            <text>2</text>

                            <line>
                            <text>1</text>

                            <line>
                            <text>5</text>

                            <line>
                            <text>2</text>

                            <line>
                            <text>1</text>

                            <line>
                            <text>3</text>

                            <line>
                            <text>1</text>

                            <line>
                            <text>2</text>

                            <line>
                            <text>5</text>
                        </g>
                        
                        <g>
                            <circle><text>u</text>
                            <circle><text>v</text>
                            <circle><text>x</text>
                            <circle><text>w</text>
                            <circle><text>y</text>
                            <circle><text>z</text>
                        </g>
                    </svg>
                    <p>Graf topologi 6 router beserta cost link antar node (Referensi Kurose &amp;
                        Ross)</p>
                </div>
            </section>

            <section>
                <h3>Tabel Simulasi Dijkstra (Step-by-Step)</h3>
                <div>
                    <div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Step</th>
                                    <th>N' (Node Terpilih)</th>
                                    <th>D(v), p(v)</th>
                                    <th>D(w), p(w)</th>
                                    <th>D(x), p(x)</th>
                                    <th>D(y), p(y)</th>
                                    <th>D(z), p(z)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>0 (Init)</td>
                                    <td><strong>u</strong></td>
                                    <td>2,u</td>
                                    <td>5,u</td>
                                    <td><strong>1,u</strong></td>
                                    <td>∞</td>
                                    <td>∞</td>
                                </tr>
                                <tr>
                                    <td>1</td>
                                    <td>u, <strong>x</strong></td>
                                    <td><strong>2,u</strong></td>
                                    <td>4,x</td>
                                    <td>-</td>
                                    <td>2,x</td>
                                    <td>∞</td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>u, x, <strong>y</strong> (pilih y)</td>
                                    <td><strong>2,u</strong></td>
                                    <td>3,y</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>4,y</td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>u, x, y, <strong>v</strong></td>
                                    <td>-</td>
                                    <td><strong>3,y</strong></td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>4,y</td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>u, x, y, v, <strong>w</strong></td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td><strong>4,y</strong></td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>u, x, y, v, w, <strong>z</strong></td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                    <td>-</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <p><em>p(v)</em> = Node pendahulu (predecessor).
                        Setelah langkah 5, tabel forwarding terbentuk, dan rute ke <code>z</code> adalah:
                        <code>u ➔ x ➔ y ➔ z</code> dengan cost total 4.
                    </p>
                    <aside>Jelaskan bahwa pada setiap iterasi kita selalu memilih node dengan estimasi
                        terkecil yang belum masuk ke himpunan N', lalu memperbarui estimasi tetangga-tetangganya.
                    </aside>
                </div>
            </section>

            <section>
                <h3>Algoritma Distance Vector: Bellman-Ford</h3>
                <div>
                    <p>Berkebalikan dengan Link-State, Distance Vector tidak menyebarkan topologi utuh. Router hanya
                        bertukar tabel estimasi jarak dengan <strong>tetangga sebelahnya saja</strong>.</p>
                    <div>
                        <strong>Persamaan Bellman-Ford (BF):</strong><br>
                        <code>D<sub>x</sub>(y) = min<sub>v</sub> { c(x,v) + D<sub>v</sub>(y) }</code>
                        <ul>
                            <li><code>D<sub>x</sub>(y):</code> Biaya minimum (estimasi) dari node x ke y.</li>
                            <li><code>min<sub>v</sub>:</code> Coba lewati setiap tetangga (v).</li>
                            <li>Pilih tetangga (v) yang memberikan akumulasi
                                <code>cost (x ke v) + cost minimum (v ke y)</code> yang paling kecil.
                            </li>
                        </ul>
                    </div>
                    <p>Penerapan: Protokol <strong>RIP (Routing Information Protocol)</strong> dan sebagian konsep dalam
                        <strong>BGP</strong> (Path Vector). Algoritma ini bersifat asinkron, iteratif, dan
                        terdesentralisasi.
                    </p>
                    <aside>Distance Vector hemat overhead broadcast, namun rentan mengalami fenomena
                        'Count to Infinity' jika terjadi link failure.</aside>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p7-s4$qa$, $qa$jarkom-p7$qa$, $qa$3. Protokol Routing di Internet$qa$, $qa$</section>

            <section>
                <h3>Routing Hierarkis: Intra-AS</h3>
                <div>
                    <p>Karena ukuran Internet sangat masif (ratusan juta router), tidak
                        mungkin menyimpan seluruh rute di satu tabel global. Internet dibagi menjadi blok-blok besar
                        otonom yang disebut <strong>Autonomous System (AS) / Domain</strong>.</p>

                    <div>
                        <div>
                            <strong><i></i> Intra-AS
                                (Interior Gateway Protocol)</strong>
                            <ul>
                                <li>Routing di <strong>dalam</strong> satu
                                    domain/ISP yang sama (kendali administratif tunggal).</li>
                                <li><strong>Fokus Utama:</strong> Optimasi
                                    performa teknis (mencari rute dengan <em>biaya minimum / cost terkecil</em>).</li>
                                <li><strong>Otonomi Penuh:</strong>
                                    Administrator jaringan bebas memilih metrik dan algoritma tanpa intervensi pihak
                                    luar.</li>
                                <li><strong>Protokol Populer:</strong>
                                    <ul>
                                        <li><strong>OSPF</strong> (Open Shortest Path First) — Link-State (Dijkstra)
                                        </li>
                                        <li><strong>IS-IS</strong> (Intermediate System to Intermediate System)</li>
                                        <li><strong>RIP</strong> (Routing Information Protocol) — Distance Vector</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                        <div>
                            <strong><i></i> Topologi &amp; Alur Intra-AS</strong>
                            <img src="https://informatika-itera.github.io/jarkom/img/week7/intra_as_routing.jpg" alt="Ilustrasi Routing Hierarkis: Intra-AS">
                            <p>Router internal
                                berkoordinasi via OSPF untuk menghitung rute biaya terpendek (Least Cost) menuju Router
                                Gerbang.</p>
                        </div>
                    </div>
                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>Intra-AS mengutamakan efisiensi performa internal
                            organisasi, di mana seluruh router internal berada di bawah kebijakan satu otoritas
                            administratif.</em>
                    </div>
                    <aside>Analogikan Intra-AS seperti navigasi lalu lintas di dalam komplek kampus atau
                        satu kota otonom. Seluruh persimpangan (router internal) bekerja sama mencari jalur paling cepat
                        menuju gerbang keluar (Gateway Router) menggunakan protokol interior seperti OSPF.</aside>
                </div>
            </section>
            <section>
                <h3>Routing Hierarkis: Inter-AS</h3>
                <div>
                    <p>Karena ukuran Internet sangat masif, routing antar organisasi yang
                        independen membutuhkan koordinasi lintas domain yang disebut <strong>Inter-AS (Exterior Gateway
                            Routing)</strong>.</p>

                    <div>
                        <div>
                            <strong><i></i> Inter-AS
                                (Exterior Gateway Protocol)</strong>
                            <ul>
                                <li>Routing <strong>antar</strong>
                                    Autonomous System / ISP yang berbeda di seluruh dunia.</li>
                                <li><strong>Fokus Kebijakan
                                        (Policy):</strong> Dipandu oleh kesepakatan bisnis, privasi, dan regulasi
                                    ekonomi, bukan sekadar jalur fisik terpendek.</li>
                                <li><strong>Dua Peran Sesi BGP:</strong>
                                    <ul>
                                        <li><strong>eBGP:</strong> Bertukar informasi rute jangkauan dengan AS tetangga.
                                        </li>
                                        <li><strong>iBGP:</strong> Menyebarkan rute eksternal ke router internal di
                                            dalam AS.</li>
                                    </ul>
                                </li>
                                <li><strong>Standar Global De Facto:</strong> <strong>BGP</strong>
                                    (Border Gateway Protocol) — <em>"lem perekat keutuhan internet global"</em>.</li>
                            </ul>
                        </div>
                        <div>
                            <strong><i></i> Topologi &amp; Sesi Inter-AS (BGP)</strong>
                            <img src="https://informatika-itera.github.io/jarkom/img/week7/inter_as_routing.jpg" alt="Ilustrasi Routing Hierarkis: Inter-AS">
                            <p>Router Gerbang menghubungkan
                                AS 1, AS 2, dan AS 3 melalui sesi eBGP dengan penegakan kebijakan bisnis (Policy
                                Routing).</p>
                        </div>
                    </div>
                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>Inter-AS mengutamakan penegakan kebijakan bisnis (policy)
                            dan kontrol privasi antar penyedia layanan, sehingga rute yang dipilih adalah rute yang
                            disepakati secara komersial.</em>
                    </div>
                    <aside>Jelaskan bahwa jika Intra-AS adalah navigasi internal satu kota, maka Inter-AS
                        adalah sistem diplomasi dan perjanjian penerbangan antar negara. BGP memungkinkan ISP menentukan
                        siapa yang boleh melintas dan jalur mana yang diumumkan ke dunia luar.</aside>
                </div>
            </section>


            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p7-s5$qa$, $qa$jarkom-p7$qa$, $qa$4. Protokol Bantuan & Manajemen$qa$, $qa$</section>

            <section>
                <h3>Apa itu ICMP?</h3>
                <div>
                    <p><strong>ICMP (Internet Control Message Protocol)</strong> digunakan oleh perangkat jaringan untuk
                        saling mengirimkan pesan kesalahan (error reporting) dan informasi operasional (diagnostik).</p>
                    <ul>
                        <li>Berada di atas (berjalan menggunakan) protokol IP. Datagram IP berisi paket ICMP.</li>
                        <li><strong>Format Pesan:</strong> Memiliki kolom Type (Tipe) dan Code (Kode) untuk
                            mengidentifikasi pesan.</li>
                    </ul>

                    <table>
                        <tr>
                            <th colspan="2">ICMP Tipe &amp; Kode Umum</th>
                            <th>Fungsi</th>
                        </tr>
                        <tr>
                            <td>Type 0</td>
                            <td>Code 0</td>
                            <td>Echo Reply (Balasan Ping Berhasil)</td>
                        </tr>
                        <tr>
                            <td>Type 8</td>
                            <td>Code 0</td>
                            <td>Echo Request (Request Pengujian Ping)</td>
                        </tr>
                        <tr>
                            <td>Type 3</td>
                            <td>Code 3</td>
                            <td>Destination Port Unreachable (Port aplikasi tujuan tertutup)</td>
                        </tr>
                        <tr>
                            <td>Type 11</td>
                            <td>Code 0</td>
                            <td>TTL Expired (Masa hidup paket habis, kunci Traceroute!)</td>
                        </tr>
                    </table>
                </div>
            </section>

            <section>
                <h3>Penerapan ICMP: Ping</h3>
                <div>
                    <div>
                        <div>
                            <div><i></i> Program: PING</div>
                            <div>
                                <p>Menguji keterjangkauan host tujuan dan mengukur waktu
                                    latensi bolak-balik (Round-Trip Time).</p>
                                <ul>
                                    <li><strong>Echo Request (Type
                                            8):</strong> Klien mengirim paket ICMP Type 8 ke alamat IP tujuan.</li>
                                    <li><strong>Echo Reply (Type
                                            0):</strong> Jika host target aktif dan tidak memfilter ICMP, ia merespons
                                        dengan paket Type 0.</li>
                                    <li><strong>Metrik Kunci:</strong>
                                        <ul>
                                            <li><strong>RTT (Latency):</strong> Waktu tempuh paket bolak-balik (ms).
                                            </li>
                                            <li><strong>Packet Loss:</strong> Persentase paket yang gagal kembali
                                                (drop/timeout).</li>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div>
                            <div><i></i> Ilustrasi
                                Alur Ping</div>
                            <div>
                                <img src="https://informatika-itera.github.io/jarkom/img/week7/icmp_ping.jpg" alt="Ilustrasi Protokol ICMP Ping">
                                <p>Pengirim mengirim ICMP
                                    Type 8 (Request) dan menerima ICMP Type 0 (Reply) untuk menghitung RTT.</p>
                            </div>
                        </div>
                    </div>
                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>Ping adalah alat diagnostik tercepat untuk memverifikasi
                            apakah host tujuan aktif pada Network Layer (Layer 3) dan mengukur latensi end-to-end.</em>
                    </div>
                    <aside>Jelaskan bahwa jika ping menampilkan Request Timed Out (RTO), kemungkinannya
                        adalah host mati, kabel putus, atau firewall tujuan memblokir paket ICMP Type 8.</aside>
                </div>
            </section>
            <section>
                <h3>Penerapan ICMP: Traceroute</h3>
                <div>
                    <div>
                        <div>
                            <div><i></i> Program: TRACEROUTE
                                (Tracert)</div>
                            <div>
                                <p>Menelusuri seluruh rute hop-by-hop dari host sumber menuju
                                    server tujuan.</p>
                                <ul>
                                    <li><strong>Inkrementasi TTL:</strong>
                                        Pengirim sengaja mengirim paket probe berurutan dengan <code>TTL = 1</code>,
                                        <code>TTL = 2</code>, <code>TTL = 3</code>, dst.
                                    </li>
                                    <li><strong>Pesan TTL Expired (Type
                                            11):</strong> Router di hop ke-<em>n</em> mengurangi TTL menjadi 0, men-drop
                                        paket, lalu membalas dengan <em>ICMP Type 11 (Time Exceeded)</em>.</li>
                                    <li><strong>Pencatatan Hop:</strong>
                                        Alamat IP pengirim pesan balasan dicatat sebagai identitas router hop tersebut
                                        bersama waktu RTT-nya.</li>
                                    <li><strong>Kondisi Berhenti:</strong> Saat mencapai host tujuan,
                                        server membalas dengan <em>ICMP Port Unreachable (Type 3)</em> atau <em>Echo
                                            Reply (Type 0)</em>.</li>
                                </ul>
                            </div>
                        </div>
                        <div>
                            <div><i></i> Ilustrasi Alur
                                Traceroute</div>
                            <div>
                                <img src="https://informatika-itera.github.io/jarkom/img/week7/icmp_traceroute.jpg" alt="Ilustrasi Protokol ICMP Traceroute">
                                <p>Pemanfaatan cerdas
                                    inkrementasi TTL bertahap &amp; pesan ICMP Type 11 untuk mengungkap rute perantara.
                                </p>
                            </div>
                        </div>
                    </div>
                    <div>
                        📌 <strong>Inti Konsep:</strong> <em>Traceroute secara kreatif memanfaatkan batas masa hidup
                            paket (TTL) untuk memancing router di sepanjang jalur mengirimkan pesan kesalahan ICMP Type
                            11 sebagai penanda jejak.</em>
                    </div>
                    <aside>Jelaskan kecerdasan mekanisme ini: Traceroute tidak memerlukan protokol
                        penelusuran rute baru, melainkan memanfaatkan secara cerdas perilaku standar IP saat TTL habis
                        (ICMP Type 11) untuk mengungkap topologi perantara satu per satu.</aside>
                </div>
            </section>

            <section>
                <h3>Network Management (SNMP)</h3>
                <div>
                    <p>Di jaringan raksasa (Enterprise), admin tidak mungkin login (SSH) ke ratusan router satu per satu
                        setiap detik untuk melihat status port. Kita butuh <strong>Network Management</strong>.</p>

                    <div>
                        <div>
                            <strong>Komponen SNMP</strong>
                            <ul>
                                <li><strong>Managing Server (Manager):</strong> Aplikasi sentral (misal: Cacti, Zabbix,
                                    Prometheus)
                                    yang bertugas menarik data.</li>
                                <li><strong>Managed Device (Agent):</strong> Router/Switch yang menjalankan aplikasi
                                    agen SNMP.</li>
                                <li><strong>MIB (Management Information Base):</strong> Struktur database hirarkis di
                                    dalam router (cth: OID untuk statistik trafik port).</li>
                            </ul>
                        </div>
                        <div>
                            <strong>Metode Pesan SNMP</strong>
                            <ul>
                                <li><code>GetRequest:</code> Manager meminta data spesifik (misal: utilisasi CPU
                                    router).</li>
                                <li><code>SetRequest:</code> Manager mengubah nilai konfigurasi di Router.</li>
                                <li><code>Trap:</code> Router melapor mandiri ke Manager saat ada kondisi bahaya (misal:
                                    port down / kabel dicabut).</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Evolusi Manajemen: NETCONF &amp; YANG</h3>
                <div>
                    <p>SNMP bagus untuk membaca data (statistik), namun sangat rumit dan jarang dipakai untuk
                        <strong>konfigurasi jaringan massal</strong> (otomasi). Internet modern menggunakan pendekatan
                        baru:
                    </p>
                    <ul>
                        <li><strong>NETCONF:</strong> Protokol berbasis RPC (Remote Procedure Call) yang aman (via
                            SSH/TLS) dan memakai format pesan <strong>XML</strong>. Bisa memanipulasi konfigurasi,
                            melakukan rollback, dan transaksi (atomic commits) pada banyak perangkat sekaligus.</li>
                        <li><strong>YANG:</strong> Bahasa pemodelan data (Data Modeling Language) yang dipakai oleh
                            NETCONF. Ia mendeskripsikan tipe data, batasan (constraints), dan struktur konfigurasi
                            perangkat layaknya sebuah skema database.</li>
                    </ul>
                    <div>
                        NETCONF dan YANG adalah tulang punggung dari <strong>SDN (Software-Defined Networking)</strong>
                        modern, karena sangat bersahabat dengan bot dan script otomasi python/Ansible.
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Rangkuman Pertemuan 7</h3>
                <div>
                    <div>
                        <p>Control Plane &amp; Routing</p>
                        <ul>
                            <li><strong>Pendekatan:</strong> Per-router (mandiri, tradisional) vs SDN (terpusat logis).
                            </li>
                            <li><strong>Dijkstra (Link-State):</strong> Info topologi global. Menghitung rute terpendek
                                dengan relaksasi
                                <code>D(v) = min(D(v), D(w)+c)</code> (Contoh: OSPF).
                            </li>
                            <li><strong>Bellman-Ford (Dist-Vector):</strong> Bertukar info vektor jarak lokal dengan
                                tetangga. Menghitung biaya minimum iteratif (Contoh: RIP, BGP).</li>
                        </ul>
                    </div>
                    <div>
                        <p>Manajemen &amp; Protokol Pendukung</p>
                        <ul>
                            <li><strong>ICMP:</strong> Untuk pelaporan error &amp; pengujian jaringan (Ping, Traceroute
                                via TTL).</li>
                            <li><strong>SNMP:</strong> Mengecek statistik router menggunakan MIB, Get, Set, dan Trap.
                            </li>
                            <li><strong>NETCONF &amp; YANG:</strong> Otomasi konfigurasi jaringan berbasis
                                XML/SSH untuk era SDN modern.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>📝 KUIS 1</h3>

                <div>
                    

                    <div>
                        <span>
                            <i></i> Portal: kuliah2.itera.ac.id
                        </span>
                        <span>
                            <i></i> Durasi: 30 Menit
                        </span>
                        <span>
                            <i></i> Ujian Daring (Online)
                        </span>
                    </div>

                    <p>
                        Pelaksanaan kuis dilakukan melalui website resmi <a href="https://kuliah2.itera.ac.id">kuliah2.itera.ac.id</a> pada mata kuliah Jaringan Komputer.<br>
                        Timer di bawah ini digunakan sebagai acuan batas waktu pengerjaan ujian.
                    </p>

                    <div>30:00</div>

                    <div>
                        <div></div>
                    </div>

                    <div>
                        <button>
                            <i></i> Mulai Ujian
                        </button>
                        <button>
                            <i></i> Jeda
                        </button>
                        <button>
                            <i></i> Reset (30m)
                        </button>
                    </div>

                    <div>Kuis siap dimulai. Klik &ldquo;Mulai Ujian&rdquo; untuk
                        memulai perhitungan waktu mundur.</div>
                </div>

                
            </section>

            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-c1$qa$, $qa$jarkom-p7$qa$, $qa$checkpoint$qa$, $qa$Algoritma Dijkstra dipakai untuk mencari...$qa$, $qa$["Kunci enkripsi terkuat", "Jalur terpendek dari satu sumber ke semua tujuan", "Alamat MAC perangkat", "Isi tabel ARP"]$qa$::jsonb, 1, $qa$Dijkstra menghitung shortest path dan jadi dasar link-state routing seperti OSPF.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-c2$qa$, $qa$jarkom-p7$qa$, $qa$checkpoint$qa$, $qa$OSPF termasuk protokol routing jenis...$qa$, $qa$["Distance vector", "Path vector", "Link state", "Static"]$qa$::jsonb, 2, $qa$OSPF adalah link-state: setiap router membangun peta topologi yang sama.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-c3$qa$, $qa$jarkom-p7$qa$, $qa$checkpoint$qa$, $qa$ICMP paling dikenal lewat perintah...$qa$, $qa$["ftp", "ping dan traceroute", "telnet", "nslookup saja"]$qa$::jsonb, 1, $qa$Ping dan traceroute memakai pesan ICMP untuk uji jangkauan dan lacak rute.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-b1$qa$, $qa$jarkom-p7$qa$, $qa$battle$qa$, $qa$Sebuah router menjalankan OSPF. Ketika topologi berubah, apa yang pertama dilakukan router?$qa$, $qa$["Menghapus seluruh tabel routing", "Membanjiri (flooding) link-state advertisement ke area-nya lalu menghitung ulang shortest path", "Beralih ke RIP otomatis", "Meminta DHCP memberi rute baru"]$qa$::jsonb, 1, $qa$OSPF menyebarkan LSA, menyinkronkan LSDB, lalu menjalankan Dijkstra ulang.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-b2$qa$, $qa$jarkom-p7$qa$, $qa$battle$qa$, $qa$Diberikan bobot lintasan: A-B=2, B-D=3, A-C=5, C-D=1. Jalur terpendek A ke D menurut Dijkstra adalah...$qa$, $qa$["A-C-D, total 6", "A-B-D, total 5", "A-C saja", "A-B-D, total 8"]$qa$::jsonb, 1, $qa$A-B-D = 2+3 = 5, lebih kecil dari A-C-D = 5+1 = 6.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-b3$qa$, $qa$jarkom-p7$qa$, $qa$battle$qa$, $qa$Pesan ICMP Destination Unreachable dikirim ketika...$qa$, $qa$["Koneksi TCP berhasil dibuat", "Router/host tidak dapat meneruskan paket ke tujuan", "DNS menemukan alamat", "Switch penuh"]$qa$::jsonb, 1, $qa$ICMP melaporkan kegagalan pengiriman, misalnya jaringan tujuan tak terjangkau.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-b4$qa$, $qa$jarkom-p7$qa$, $qa$battle$qa$, $qa$SNMP dipakai administrator jaringan untuk...$qa$, $qa$["Mengenkripsi email", "Memantau dan mengelola perangkat jaringan (router, switch, server)", "Mengganti fungsi routing", "Membuat kabel"]$qa$::jsonb, 1, $qa$SNMP adalah protokol manajemen: memantau status dan kinerja perangkat.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p7-b5$qa$, $qa$jarkom-p7$qa$, $qa$battle$qa$, $qa$NETCONF/YANG dalam manajemen jaringan modern berperan sebagai...$qa$, $qa$["Protokol email", "Mekanisme konfigurasi perangkat berbasis model data (YANG) lewat NETCONF", "Algoritma routing", "Standar kabel"]$qa$::jsonb, 1, $qa$YANG memodelkan konfigurasi, NETCONF protokol untuk menerapkannya ke perangkat.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
