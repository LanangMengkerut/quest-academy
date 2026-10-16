insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p1$qa$, $qa$jarkom$qa$, $qa$Pengantar Jaringan Komputer$qa$, $qa$<h3>Definisi & Klasifikasi</h3>
<p><strong>Jaringan komputer</strong> adalah sekumpulan komputer dan perangkat yang saling terhubung melalui fasilitas komunikasi untuk bertukar data dan berbagi sumber daya.</p>
<ul>
<li><strong>Berdasarkan cakupan:</strong> LAN (area kecil: rumah/kantor), MAN (satu kota), WAN (antar kota/negara, contoh: internet).</li>
<li><strong>Berdasarkan manajemen:</strong> Client-Server (ada server pusat melayani client) vs Peer-to-Peer (semua komputer sederajat).</li>
</ul>
<h3>Dua Cara Memandang Internet</h3>
<ul>
<li><strong>Nuts and bolts:</strong> internet sebagai infrastruktur — end systems, communication links, packet switches (router & switch), ISP.</li>
<li><strong>Services view:</strong> internet sebagai layanan bagi aplikasi terdistribusi (web, email, game); program berkomunikasi lewat <strong>socket interface</strong>.</li>
</ul>
<h3>Protokol & Standar</h3>
<p><strong>Protokol</strong> mendefinisikan format dan urutan pesan yang dipertukarkan serta tindakan saat mengirim dan menerima. Tanpa protokol, bit yang diterima hanyalah sampah digital.</p>
<ul>
<li>Standarisasi oleh <strong>IETF</strong> (dokumen: RFC) dan <strong>IEEE</strong> (mis. 802.11 untuk Wi-Fi) agar perangkat beda vendor bisa saling bicara.</li>
</ul>
<h3>Network Edge & Core</h3>
<ul>
<li><strong>Access network:</strong> HFC/kabel TV (shared), FTTH/fiber (cepat, PON), DSL (kabel telepon, dedicated), seluler 4G/5G.</li>
<li><strong>Media fisik:</strong> guided (kabel tembaga, fiber) vs unguided (radio, satelit).</li>
<li><strong>Packet switching:</strong> data dipecah jadi paket, diteruskan per-hop secara store-and-forward; bisa antre (queuing delay) dan hilang (packet loss) saat buffer penuh.</li>
<li><strong>Circuit switching:</strong> jalur eksklusif dipesan selama sesi (telepon lama) — terjamin tapi boros; dibagi via FDM/TDM.</li>
<li><strong>Forwarding</strong> = memindahkan paket dari input ke output link (lokal, cepat); <strong>Routing</strong> = menentukan rute end-to-end (global, via routing protocol yang meng-update forwarding table).</li>
</ul>
<h3>QoS: Delay, Loss, Throughput</h3>
<p>Total delay = d_proc + d_queue + d_trans + d_prop.</p>
<ul>
<li><strong>Processing:</strong> cek header/error di router. <strong>Queuing:</strong> antre di buffer (paling tak terduga). <strong>Transmission:</strong> mendorong bit ke kabel (tergantung bandwidth). <strong>Propagation:</strong> perjalanan fisik bit (tergantung jarak).</li>
<li><strong>Throughput</strong> dibatasi oleh <strong>bottleneck link</strong> — link tersempit di jalur.</li>
</ul>
<h3>Keamanan Jaringan</h3>
<ul>
<li><strong>Virus</strong> butuh interaksi pengguna; <strong>worm</strong> menyebar otomatis lewat celah jaringan.</li>
<li><strong>DoS/DDoS:</strong> banjir trafik hingga server lumpuh; DDoS memakai botnet.</li>
<li><strong>Sniffing:</strong> menguping paket (lawan: enkripsi). <strong>Spoofing:</strong> memalsukan alamat IP pengirim.</li>
</ul>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan01.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 1) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s1$qa$, $qa$jarkom-p1$qa$, $qa$Pengantar Jaringan Komputer$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>
            
            <section>
                <div>
                    
                    <h3>Pertemuan 1</h3>
                </div>
                <div>
                    <strong>Referensi:</strong><br>
                    1. Kurose & Ross - <em>Computer Networking: A Top-Down Approach</em><br>
                    2. Forouzan, B. A. - <em>Data Communications and Networking</em><br>
                    3. Tanenbaum, A. S. - <em>Computer Networks</em>
                </div>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
                <aside>
                    Selamat pagi/siang semuanya. Selamat datang di mata kuliah Jaringan Komputer. Mari kita pelajari
                    pondasi internet hari ini.
                </aside>
            </section>

            <section>
                <h3>Outline Materi</h3>
                <ul>
                    <li>Pengertian & Klasifikasi Jaringan</li>
                    <li>1.1 Apa itu Internet?</li>
                    <li>1.2 The Network Edge (Pinggiran Jaringan)</li>
                    <li>1.3 The Network Core (Inti Jaringan)</li>
                    <li>1.4 QoS (Delay, Loss, dan Throughput)</li>
                    <li>1.5 Protocol Layers (OSI & TCP/IP)</li>
                    <li>1.6 Keamanan Jaringan (Pengantar)</li>
                    <li>1.7 Sejarah Singkat Jaringan</li>
                    <li>Tugas / PR</li>
                </ul>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s2$qa$, $qa$jarkom-p1$qa$, $qa$Pengertian Jaringan Komputer$qa$, $qa$<div>
                    <p><strong>Menurut KBBI:</strong> Sekelompok komputer dan perangkat terkait yang dihubungkan dengan
                        fasilitas komunikasi.</p>
                    <p>Secara umum, <strong>Jaringan Komputer</strong> adalah sekumpulan komputer yang saling terhubung
                        sehingga memungkinkan komunikasi, pertukaran data, dan pemanfaatan sumber daya secara bersama.
                    </p>
                </div>
            </section>

            <section>
                <h3>Mengapa Jaringan Komputer Penting?</h3>
                <div>
                    <ul>
                        <li>Memudahkan berbagi data dan informasi secara instan.</li>
                        <li>Memungkinkan komunikasi global yang masif (Email, Video Call, Chat).</li>
                        <li>Menghubungkan pengguna dengan pasar yang luas (E-Commerce).</li>
                        <li>Berbagai sektor industri kini sangat bergantung pada infrastruktur jaringan yang handal.
                        </li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Klasifikasi Jaringan</h3>
                <div>
                    <h4>Berdasarkan Cakupan Area:</h4>
                    <ul>
                        <li><strong>LAN (Local Area Network):</strong> Mencakup area kecil seperti rumah, kantor, lab.
                        </li>
                        <li><strong>MAN (Metropolitan Area Network):</strong> Mencakup area kota atau kampus besar.</li>
                        <li><strong>WAN (Wide Area Network):</strong> Mencakup area luas, antar kota/negara (contoh:
                            Internet).</li>
                    </ul>
                    <h4>Berdasarkan Metode Manajemen:</h4>
                    <ul>
                        <li><strong>Client-Server:</strong> Ada komputer pusat (server) yang melayani komputer lain
                            (client).</li>
                        <li><strong>Peer-to-Peer:</strong> Semua komputer memiliki kedudukan yang sama.</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s3$qa$, $qa$jarkom-p1$qa$, $qa$1.1 Apa Itu Internet?$qa$, $qa$<aside>Mari kita mulai dengan mendefinisikan internet.</aside>
            </section>

            <section>
                <h3>Dua Pendekatan Definisi Internet</h3>
                
                
                <div>
                    <div>
                        <div><i></i></div>
                        <h4>1. Nuts and Bolts</h4>
                        <p>Mendefinisikan internet berdasarkan <strong>infrastruktur
                                perangkat keras</strong> (kabel, router) dan perangkat lunaknya.</p>
                    </div>
                    <div>
                        <div><i></i></div>
                        <h4>2. Services View</h4>
                        <p>Mendefinisikan internet sebagai infrastruktur yang melayani
                            <strong>aplikasi terdistribusi</strong> (Web, Game, Email, dll).
                        </p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Nuts and Bolts: Gambaran Lengkap</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide3_nuts_bolts.png" alt="Kurose Figure 1.1 - Internet Nuts and Bolts View">
                <aside>Ini adalah gambaran lengkap komponen Internet dari Kurose & Ross: end systems,
                    packet switches, communication links, dan networks.</aside>
            </section>

            
            <section>
                <h3>"Fun" Internet-Connected Devices</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide4_fun_devices.png" alt="Fun Internet-Connected Devices">
                <aside>End systems bukan hanya komputer — hampir semua perangkat sekarang bisa terhubung
                    ke Internet.</aside>
            </section>

            
            <section>
                <h3>Nuts and Bolts: Protokol &amp; Standar Internet</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide5_protocols.png" alt="Internet Protocols and Standards">
                <aside>Protokol ada di mana-mana: HTTP, IP, TCP, WiFi, 4G, Ethernet. Standar diatur oleh
                    IETF melalui RFC.</aside>
            </section>

            
            <section>
                <h3>Services View: Internet sebagai Layanan</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide6_services.png" alt="The Internet: a Services View">
                <aside>Dari sudut pandang layanan: Internet menyediakan programming interface ke aplikasi
                    terdistribusi (Web, streaming, game, email).</aside>
            </section>

            

            <section>
                <h3>Nuts and Bolts: Communication Links</h3>
                <div>
                    <ul>
                        <li>End systems dihubungkan oleh <strong>Communication Links</strong> (jalur komunikasi).</li>
                        <li>Media fisik: kabel tembaga, serat optik, dan gelombang radio (Wi-Fi, 5G).</li>
                        <li>Setiap link memiliki kapasitas <strong>Transmission Rate</strong> (bit/sec).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Nuts and Bolts: Packet Switches</h3>
                <div>
                    <p>Data diteruskan oleh perangkat yang disebut <strong>Packet Switch</strong>. Ada dua jenis utama:
                    </p>
                </div>
                
                
                <div>
                    
                    <div>
                        <i></i>
                        <h4>Router
                        </h4>
                        <ul>
                            <li>Bekerja di Layer 3 (Network).</li>
                            <li>Merutekan paket antar jaringan.</li>
                            <li>Ditemukan di inti jaringan (Network Core).</li>
                            <li>Tugas kompleks (IP Addressing).</li>
                        </ul>
                    </div>
                    
                    <div>
                        <i></i>
                        <h4>
                            Link-Layer Switch</h4>
                        <ul>
                            <li>Bekerja di Layer 2 (Data Link).</li>
                            <li>Meneruskan paket dalam satu jaringan.</li>
                            <li>Ditemukan di Access Network/LAN lokal.</li>
                            <li>Tugas lebih cepat (MAC Addressing).</li>
                        </ul>
                    </div>
                </div>
            </section>

            <section>
                <h3>Nuts and Bolts: Network of Networks</h3>
                <div>
                    <ul>
                        <li>Anda mengakses internet melalui <strong>ISP (Internet Service Provider)</strong>.</li>
                        <li>Contoh: Telkomsel, Indihome, Biznet.</li>
                        <li>Internet adalah jaringan raksasa yang menghubungkan ISP-ISP ini secara global.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Service View: Infrastruktur Aplikasi</h3>
                <div>
                    <ul>
                        <li>Dari sudut pandang layanan, internet melayani <strong>Aplikasi Terdistribusi</strong>.</li>
                        <li>Aplikasi berjalan di <em>End Systems</em> (PC, Server), bukan di dalam Router.</li>
                        <li>Contoh aplikasi: Web, Email, Streaming Video, Game Online.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Service View: Socket Interface</h3>
                <div>
                    <ul>
                        <li>Bagaimana program mengirim data ke program lain?</li>
                        <li>Menggunakan <strong>Socket Interface</strong> (API standar).</li>
                        <li>Analogi: Anda menulis surat dan harus memasukkannya ke kotak pos agar kantor pos tahu apa
                            yang harus dilakukan.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Apa itu Protokol?</h3>
                <div>
                    <blockquote>
                        "Sebuah protokol mendefinisikan <strong>format</strong> dan <strong>urutan</strong> pesan yang
                        dipertukarkan, serta <strong>tindakan</strong> yang diambil saat mentransmisikan dan menerima
                        pesan."
                    </blockquote>
                    <p>Tanpa protokol, komputer penerima hanya akan melihat kumpulan bit tanpa makna (sampah digital).
                    </p>
                </div>
            </section>

            <section>
                <h3>Analogi Protokol</h3>
                <div>
                    <h4>Protokol Manusia (Tanya Waktu)</h4>
                    <ol>
                        <li>A berkata "Halo"</li>
                        <li>B menjawab "Halo"</li>
                        <li>A bertanya "Jam berapa?"</li>
                        <li>B menjawab "Jam 2."</li>
                    </ol>
                    <h4>Protokol Komputer (Web Request)</h4>
                    <ol>
                        <li>PC kirim TCP SYN</li>
                        <li>Server jawab TCP SYN ACK</li>
                        <li>PC minta "GET index.html"</li>
                        <li>Server kirim file web HTML.</li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Standar Internet</h3>
                <div>
                    <ul>
                        <li><strong>Standarisasi:</strong> Memastikan perangkat dari vendor berbeda (misal Apple dan
                            Microsoft) bisa saling mengobrol.</li>
                        <li><strong>IETF (Internet Engineering Task Force):</strong> Pembuat standar internet.
                            Dokumennya disebut <strong>RFC</strong> (Request For Comments).</li>
                        <li><strong>IEEE:</strong> Standar untuk hardware (Contoh: IEEE 802.11 untuk Wi-Fi).</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s4$qa$, $qa$jarkom-p1$qa$, $qa$1.2 The Network Edge$qa$, $qa$<p>Mendalami bagian "Pinggiran" dari jaringan.</p>
                <div>
                    <div>
                        <i></i>
                        <div>End System (Client)</div>
                    </div>
                    <div><i></i></div>
                    <div>
                        <i></i>
                        <div>Network Core</div>
                    </div>
                    <div><i></i></div>
                    <div>
                        <i></i>
                        <div>End System (Server)</div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>A closer look at Internet structure: Network Edge</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_10_network_edge.png" alt="A closer look at Internet structure: Network Edge">
                <aside>Di bagian ujung jaringan (Network Edge) terdapat Hosts: yaitu clients dan servers.
                    Server biasanya ditempatkan di data centers.</aside>
            </section>

            
            <section>
                <h3>A closer look at Internet structure: Access Networks</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_11_access_networks_intro.png" alt="A closer look at Internet structure: Access Networks Intro">
                <aside>Untuk mengakses internet, end systems terhubung menggunakan Access networks (wired,
                    wireless communication links).</aside>
            </section>

            
            <section>
                <h3>A closer look at Internet structure: Network Core</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_12_network_core.png" alt="A closer look at Internet structure: Network Core">
                <aside>Di bagian inti (Network Core), terdapat kumpulan router yang saling terhubung
                    membentuk "network of networks".</aside>
            </section>

            
            <section>
                <h3>Access networks and physical media</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_13_access_networks.png" alt="Access networks and physical media">
                <aside>Bagaimana menghubungkan End Systems ke Edge Router? Menggunakan Access Networks
                    (residential, institutional, mobile/wireless).</aside>
            </section>

            <section>
                <h3>Access Networks</h3>
                <div>
                    <p>Jalur fisik penghubung dari komputer Anda ke Edge Router ISP disebut <strong>Access
                            Network</strong>.</p>
                    <p>Tiga jenis utama:</p>
                    <ol>
                        <li>Home Access (Akses Rumahan)</li>
                        <li>Enterprise Access (Kantor/Kampus)</li>
                        <li>Wide-Area Wireless Access (Seluler 4G/5G)</li>
                    </ol>
                </div>
            </section>

            
            <section>
                <h3>Access networks: cable-based access</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_14_cable_fdm.png" alt="Access networks: cable-based access (FDM)">
                <aside>Pada jaringan akses berbasis kabel TV, frekuensi dibagi-bagi untuk data dan video.
                    Ini disebut frequency division multiplexing (FDM), dimana channel yang berbeda ditransmisikan pada
                    pita frekuensi yang berbeda.</aside>
            </section>

            
            <section>
                <h3>Access networks: cable-based access (HFC)</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_15_cable_hfc.png" alt="Access networks: cable-based access (HFC)">
                <aside>Infrastruktur ini disebut HFC (hybrid fiber coax). Data dan TV ditransmisikan pada
                    frekuensi yang berbeda melalui jaringan kabel bersama (shared network). Kecepatannya asimetris,
                    lebih cepat saat download (downstream) daripada upload (upstream).</aside>
            </section>

            <section>
                <h3>Home Access: Cable Internet</h3>
                <div>
                    <h4>Cable Internet (HFC)</h4>
                    <ul>
                        <li>Memanfaatkan infrastruktur kabel antena TV (Coaxial).</li>
                        <li>Sering disebut HFC (Hybrid Fiber Coax).</li>
                        <li>Kabel ini bersifat <strong>Shared</strong>. Artinya Anda dan tetangga Anda berbagi bandwidth
                            (bisa melambat saat jam sibuk).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Home Access: FTTH</h3>
                <div>
                    <h4>FTTH (Fiber To The Home)</h4>
                    <ul>
                        <li>Kabel fiber optik ditarik dari sentral ISP langsung menuju rumah.</li>
                        <li>Sangat cepat (bisa ratusan Mbps hingga Gbps).</li>
                        <li>Menggunakan PON (Passive Optical Network) dengan *splitter* cahaya. (Contoh: Biznet,
                            Indihome FTTH).</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Access networks: digital subscriber line (DSL)</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_16_dsl.png" alt="Access networks: digital subscriber line (DSL)">
                <aside>DSL menggunakan jalur telepon yang sudah ada untuk akses internet. Data internet
                    dikirim ke DSLAM, sementara suara dikirim ke jaringan telepon. DSL adalah sambungan dedicated (tidak
                    dibagi dengan tetangga), dengan kecepatan yang juga asimetris.</aside>
            </section>

            <section>
                <h3>Home Access: DSL</h3>
                <div>
                    <h4>DSL (Digital Subscriber Line)</h4>
                    <ul>
                        <li>Memanfaatkan kabel telepon tembaga (twisted-pair) rumah yang sudah ada menuju sentral
                            telepon.</li>
                        <li>Data internet dan suara telepon berjalan di frekuensi yang berbeda.</li>
                        <li>Koneksinya <strong>Dedicated</strong> (tidak dibagi dengan tetangga).</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Access networks: home networks</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_17_home_networks.png" alt="Access networks: home networks">
                <aside>Dalam jaringan rumah (home network), biasanya terdapat modem (kabel/DSL),
                    router/firewall/NAT, switch lokal, dan WiFi access point. Seringkali semua fungsi ini digabung dalam
                    satu perangkat (single box).</aside>
            </section>

            <section>
                <h3>Home Network Layout</h3>
                <div>
                    <p>Di rumah Anda, ada jaringan lokal (LAN) kecil:</p>
                    <ul>
                        <li><strong>Modem (ONT/DSL):</strong> Pengubah sinyal masuk ISP.</li>
                        <li><strong>Router:</strong> Merutekan paket dalam jaringan lokal ke internet.</li>
                        <li><strong>Wi-Fi Access Point:</strong> Penghubung perangkat nirkabel.</li>
                    </ul>
                    <p><em>(Saat ini, ketiganya sering digabung dalam 1 kotak plastik dari ISP).</em></p>
                </div>
            </section>

            
            <section>
                <h3>Wireless access networks</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_18_wireless.png" alt="Wireless access networks">
                <aside>Jaringan akses nirkabel terbagi dua: Wireless LANs (seperti WiFi) yang mencakup
                    area kecil dalam gedung, dan Wide-area cellular networks (seperti 4G/5G) yang disediakan oleh
                    operator seluler dengan jangkauan lebih luas (puluhan km).</aside>
            </section>

            <section>
                <h3>Wide-Area Wireless Access</h3>
                <div>
                    <p>Akses internet *Mobile* via menara seluler (BTS).</p>
                    <ul>
                        <li>Cakupan sinyal mencapai puluhan kilometer (dibandingkan Wi-Fi yang hanya puluhan meter).
                        </li>
                        <li>Standar modern: <strong>LTE (4G)</strong> dan <strong>5G</strong>.</li>
                        <li>Keunggulan utama adalah mobilitas penggunanya.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Physical Media (Media Fisik)</h3>
                <div>
                    <p>Bit-bit informasi harus berjalan di atas media fisik dalam bentuk energi (listrik, cahaya,
                        radio).</p>
                    <ul>
                        <li><strong>Guided Media:</strong> Gelombang diarahkan melalui medium
                            padat. (Kabel tembaga, fiber optik).</li>
                        <li><strong>Unguided Media:</strong> Gelombang disebarkan bebas di
                            atmosfer atau ruang angkasa (Radio, satelit).</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Guided Media: Kabel Tembaga</h3>
                <div>
                    <h4>Twisted-Pair (UTP)</h4>
                    <p>Kabel tembaga berinsulasi yang dipilin spiral. Pilinan ini berfungsi menghilangkan interferensi
                        (noise). Paling murah dan populer untuk LAN.</p>
                    <h4>Coaxial Cable</h4>
                    <p>Dua tembaga konsentris (sepusat). Cocok untuk membawa frekuensi tinggi seperti siaran TV kabel
                        dan internet shared-medium.</p>
                </div>
                <div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/chapter1/image79.jpeg" alt="Twisted Pair">
                        <div>Twisted-Pair (UTP)</div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/chapter1/image78.jpeg" alt="Coaxial Cable">
                        <div>Coaxial Cable</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Guided Media: Fiber Optics</h3>
                <div>
                    <ul>
                        <li>Serat kaca yang fleksibel, menghantarkan pulsa cahaya.</li>
                        <li>Satu pulsa cahaya = satu bit informasi.</li>
                        <li>Kecepatan luar biasa tinggi dan <strong>kebal interferensi
                                listrik</strong>.</li>
                        <li>Cocok membentang di dasar samudra antar benua (karena redaman sinyalnya sangat kecil).</li>
                    </ul>
                </div>
                <div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/chapter1/image80.png" alt="Fiber Optic 1">
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/chapter1/image81.png" alt="Fiber Optic 2">
                    </div>
                </div>
            </section>

            <section>
                <h3>Unguided Media: Radio & Satelit</h3>
                <div>
                    <h4>Terrestrial Radio</h4>
                    <p>Gelombang Wi-Fi, 4G. Rawan pantulan dinding dan gangguan cuaca.</p>
                    <h4>Satellite Radio</h4>
                    <ul>
                        <li><strong>Geostationary:</strong> Satelit jauh (36.000 km), delay propagasi sangat besar (~280
                            ms).</li>
                        <li><strong>LEO (Low Earth Orbit):</strong> Satelit dekat bumi. Jauh lebih cepat, butuh
                            konstelasi banyak satelit (Contoh: Starlink).</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Access networks: enterprise networks</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_19_enterprise.png" alt="Access networks: enterprise networks">
                <aside>Jaringan perusahaan atau kampus biasanya terdiri dari gabungan koneksi kabel
                    (Ethernet) dan nirkabel (WiFi) yang terhubung ke sekumpulan switch dan router, sebelum akhirnya
                    terhubung ke ISP luar.</aside>
            </section>

            <section>
                <h3>Enterprise Access (LAN)</h3>
                <div>
                    <p>Jaringan untuk kantor atau kampus besar.</p>
                    <ul>
                        <li>Mengandalkan kabel <strong>Ethernet</strong> ke meja pegawai, dan <strong>Wi-Fi</strong>
                            untuk area publik.</li>
                        <li>Menghubungkan ratusan komputer ke <strong>Ethernet Switch</strong> berkecepatan tinggi (1
                            Gbps - 10 Gbps).</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Access networks: data center networks</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_20_datacenter.png" alt="Access networks: data center networks">
                <aside>Jaringan pusat data (data center) menghubungkan ratusan hingga ribuan server
                    bersama-sama menggunakan koneksi berkecepatan sangat tinggi (10 sampai 100 Gbps). Ini penting untuk
                    penyedia layanan besar seperti Google atau Amazon.</aside>
            </section>

            
            <section>
                <h3>Host: sends packets of data</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_21_host_sends.png" alt="Host: sends packets of data">
                <aside>Saat host mengirim pesan, pesan tersebut dipecah menjadi potongan-potongan kecil
                    yang disebut "packets" dengan panjang L bit. Paket-paket ini lalu dikirim melalui access network
                    dengan kecepatan transmisi (transmission rate/bandwidth) sebesar R bits/sec.</aside>
            </section>

            <section>
                <h3>Packet Switching</h3>
                <div>
                    <p>Di internet, data yang panjang dipecah-pecah menjadi banyak <strong>Paket (Packets)</strong>
                        kecil sebelum dikirim.</p>
                    <p>Setiap paket menempuh perjalanan melalui router satu per satu.</p>
                </div>
                <div>
                    <div>
                        <div></div>
                        <div></div>
                    </div>
                    <div><i></i></div>
                    <div>
                        <div>
                            <div></div>
                            <div></div>
                            <div></div>
                        </div>
                        <i></i>
                        <div>Router Buffer</div>
                    </div>
                    <div><i></i></div>
                    <div></div>
                </div>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s5$qa$, $qa$jarkom-p1$qa$, $qa$1.3 The Network Core$qa$, $qa$<p>Jantung Internet: <em>Mesh of interconnected routers</em>.</p>
            </section>


            
            <section>
                <h3>The network core</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_26_network_core.png" alt="The network core">
                <aside>Masuk ke Network Core: Ini adalah sekumpulan router yang saling terhubung membentuk
                    "jaring" (mesh). Network Core menggunakan teknik "packet-switching", di mana jaringan meneruskan
                    paket dari satu router ke router berikutnya sampai mencapai tujuan.</aside>
            </section>

            
            <section>
                <h3>Two key network-core functions</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_27_core_functions.png" alt="Two key network-core functions">
                <aside>Di dalam Network Core, ada dua fungsi utama: Forwarding dan Routing. Forwarding
                    adalah aksi lokal memindahkan paket dari pintu masuk router ke pintu keluar yang tepat. Routing
                    adalah aksi global menentukan rute atau jalur dari sumber ke tujuan menggunakan algoritma.</aside>
            </section>

            
            <section>
                <h3>Routing</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_28_routing.png" alt="Routing">
                <aside>Routing adalah proses global yang menentukan jalur tempuh dari sumber (source) ke
                    tujuan (destination). Ibarat merencanakan perjalanan jauh melintasi berbagai negara bagian dari awal
                    sampai akhir.</aside>
            </section>

            
            <section>
                <h3>Forwarding</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_29_forwarding.png" alt="Forwarding">
                <aside>Sedangkan Forwarding adalah proses lokal pada setiap titik persimpangan (router).
                    Ibaratnya ketika Anda sampai di persimpangan jalan, Anda hanya memutuskan mau belok kiri atau kanan
                    untuk lanjut ke rute berikutnya.</aside>
            </section>

            <section>
                <h3>Forwarding Tables & Routing</h3>
                <div>
                    <p>Bagaimana router tahu arah yang benar?</p>
                    <ul>
                        <li>Setiap paket membawa alamat <strong>IP Address Tujuan</strong>.</li>
                        <li>Router melihat IP tersebut, lalu mencocokkannya dengan peta panduan miliknya yang disebut
                            <strong>Forwarding Table</strong>.
                        </li>
                        <li><strong>Routing Protocol</strong> adalah algoritma AI/matematika yang bertugas memperbarui
                            tabel ini agar rute selalu optimal.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Packet-switching: store-and-forward</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_30_store_forward.png" alt="Packet-switching: store-and-forward">
                <aside>Packet-switching menggunakan prinsip store-and-forward. Artinya, router harus
                    menerima keseluruhan paket (semua bit-nya) terlebih dahulu sebelum bisa mulai mengirimkannya ke link
                    berikutnya. Ini menimbulkan delay transmisi sebesar L/R detik.</aside>
            </section>

            <section>
                <h3>Store-and-Forward Transmission</h3>
                <div>
                    <p>Ini adalah prinsip kerja router packet-switching:</p>
                    <ul>
                        <li>Router harus <strong>menerima dan menyimpan utuh (store)</strong> seluruh bit dari satu
                            paket ke memorinya.</li>
                        <li>Hanya setelah paket diterima lengkap tanpa cacat, router akan <strong>meneruskannya
                                (forward)</strong> ke link berikutnya.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Packet-switching: queueing</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_31_queueing_1.png" alt="Packet-switching: queueing">
                <aside>Masalah yang sering terjadi adalah Antrean (Queueing). Antrean terjadi ketika laju
                    kedatangan paket (work arrival) lebih cepat daripada kecepatan layanan atau kapasitas link keluar
                    (transmission rate).</aside>
            </section>

            
            <section>
                <h3>Packet-switching: queueing and loss</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_32_queueing_2.png" alt="Packet-switching: queueing and loss">
                <aside>Akibat dari queueing adalah "Packet loss" atau paket hilang. Paket-paket akan
                    mengantre di buffer router, dan jika antrean penuh melebihi kapasitas memori, maka paket yang baru
                    datang akan dibuang atau di-drop.</aside>
            </section>

            <section>
                <h3>Queuing Delay dan Packet Loss</h3>
                <div>
                    <p>Setiap router memiliki <strong>Output Buffer (Antrean)</strong>.</p>
                    <ul>
                        <li><strong>Queuing Delay:</strong> Terjadi jika paket datang tapi link
                            keluaran masih sibuk mengirim paket lain. Paket harus mengantre.</li>
                        <li><strong>Packet Loss:</strong> Jika antrean memori penuh dan ada paket
                            baru datang, router terpaksa membuang (drop) paket tersebut.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Alternative to packet switching: circuit switching</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_33_circuit_switching.png" alt="Circuit switching">
                <aside>Sebagai alternatif dari packet-switching, ada "circuit switching". Pada circuit
                    switching, resource atau jalur komunikasi (bandwidth) dialokasikan dan di-reserve khusus sejak awal
                    (dedicated) untuk satu panggilan/komunikasi dari sumber ke tujuan. Umumnya digunakan pada jaringan
                    telepon tradisional.</aside>
            </section>

            <section>
                <h3>Circuit Switching (Alternatif Lama)</h3>
                <div>
                    <p>Jaringan telepon tradisional menggunakan <strong>Circuit Switching</strong>.</p>
                    <ul>
                        <li>Jalur komunikasi (sirkuit) <strong>dipesan/dialokasikan eksklusif</strong> untuk Anda selama
                            sesi berlangsung.</li>
                        <li>Kinerja terjamin 100% tanpa delay antrean.</li>
                        <li>Namun, sangat boros. Jika Anda sedang diam tidak menelepon, kabel itu tetap tidak boleh
                            dipakai orang lain.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Circuit switching: FDM and TDM</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_34_fdm_tdm.png" alt="Circuit switching: FDM and TDM">
                <aside>Circuit switching biasanya diimplementasikan dengan dua cara: FDM (Frequency
                    Division Multiplexing) membagi bandwidth berdasarkan frekuensi, sedangkan TDM (Time Division
                    Multiplexing) membagi bandwidth berdasarkan slot waktu.</aside>
            </section>

            <section>
                <h3>Multiplexing di Circuit Switching</h3>
                <div>
                    <p>Cara membagi 1 kabel untuk banyak panggilan telepon:</p>
                    <ul>
                        <li><strong>FDM (Frequency-Division):</strong> Kabel dibagi menjadi
                            frekuensi berbeda-beda layaknya frekuensi stasiun radio FM.</li>
                        <li><strong>TDM (Time-Division):</strong> Waktu dibagi bergiliran dalam
                            slot mikrodetik (giliran A, giliran B, giliran A lagi).</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Packet switching versus circuit switching</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_35_packet_vs_circuit.png" alt="Packet switching vs circuit switching">
                <aside>Packet switching memungkinkan lebih banyak pengguna untuk berbagi kapasitas
                    jaringan yang sama (karena sifatnya yang on-demand) dibandingkan circuit switching yang jalurnya
                    eksklusif (dedicated) dan tidak bisa dipakai orang lain walau sedang tidak ada transmisi (idle).
                </aside>
            </section>

            <section>
                <h3>Packet vs Circuit Switching</h3>
                <div>
                    <p>Mengapa Internet memilih Packet Switching?</p>
                    <ul>
                        <li><strong>Resource Sharing:</strong> Karena internet bersifat <em>bursty</em> (diam lama saat
                            baca web, lalu tiba-tiba butuh download file). Packet switching memungkinkan kabel dipakai
                            ramai-ramai.</li>
                        <li>Jauh lebih efisien dan murah.</li>
                        <li><span>Kelemahannya:</span> Jika lalu lintas penuh, terjadi macet parah
                            (congestion) dan delay tak menentu.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Internet structure: a “network of networks”</h3>
                <img src="https://informatika-itera.github.io/jarkom/img/pptx_slide_1_36_network_of_networks.png" alt="Network of networks">
                <aside>Internet adalah kumpulan jaringan-jaringan (network of networks). Host terhubung ke
                    ISP lokal (Access ISPs), dan ISP-ISP ini juga harus saling terhubung satu sama lain secara hierarkis
                    (melalui regional dan global ISP) agar host manapun di dunia bisa saling berinteraksi.</aside>
            </section>

            <section>
                <h3>Network of Networks</h3>
                <div>
                    <ul>
                        <li><strong>Tier-1 ISPs:</strong> ISP global raksasa (AT&T, Level 3). Backbone internet dunia.
                        </li>
                        <li><strong>Regional ISPs:</strong> ISP tingkat negara/pulau yang menyewa jalur dari Tier-1.
                        </li>
                        <li><strong>IXP (Internet Exchange Point):</strong> Tempat pertemuan fisik berbagai ISP untuk
                            saling menukar paket secara gratis/murah demi efisiensi.</li>
                        <li><strong>Content Provider Networks:</strong> Jaringan pribadi Google/Microsoft yang
                            mem-bypass ISP publik.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Host: Client & Server</h3>
                <div>
                    <p>End systems di ujung jaringan terbagi menjadi dua:</p>
                    <ul>
                        <li><strong>Clients:</strong> Perangkat (laptop, HP) yang mengajukan
                            permintaan layanan.</li>
                        <li><strong>Servers:</strong> Mesin kuat di <em>Data Center</em>
                            (Google, Amazon) yang melayani permintaan web, email, dll.</li>
                    </ul>
                </div>
            </section>





















            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s6$qa$, $qa$jarkom-p1$qa$, $qa$1.4 Quality of Service (QoS)$qa$, $qa$<p>Delay, Loss, dan Throughput</p>
            </section>

            <section>
                <h3>4 Sumber Delay Keterlambatan (Bag. 1)</h3>
                <div>
                    <p>Total Delay = d_proc + d_queue + d_trans + d_prop</p>
                    <ol>
                        <li><strong>Processing Delay (d_proc):</strong> Waktu bagi router untuk
                            memeriksa header paket dan mengecek error. (Sangat cepat, hitungan mikrosekon).</li>
                        <li><strong>Queuing Delay (d_queue):</strong> Waktu menunggu dalam
                            antrean buffer router sebelum bisa masuk ke kabel. (Paling sulit diprediksi, tergantung
                            kemacetan).</li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>4 Sumber Delay Keterlambatan (Bag. 2)</h3>
                <div>
                    <ol>
                        <li><strong>Transmission Delay (d_trans):</strong> Waktu yang butuh
                            untuk "mendorong" semua bit paket masuk ke dalam kabel. Bergantung pada <em>Bandwidth</em>
                            link, bukan jarak.</li>
                        <li><strong>Propagation Delay (d_prop):</strong> Waktu perjalanan fisik
                            sebuah bit melintasi panjang kabel dengan kecepatan cahaya. Bergantung pada jarak antar
                            negara/kota.</li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>Analogi Karavan Mobil (Transmission vs Propagation)</h3>
                <div>
                    <ul>
                        <li>Sebuah paket diibaratkan rombongan 10 mobil.</li>
                        <li>Waktu mendorong 10 mobil melewati gerbang tol lambat = <strong>Transmission Delay</strong>.</li>
                        <li>Waktu mobil melaju dari pintu tol Jakarta ke pintu tol Bandung (jarak tempuh) = <strong>Propagation Delay</strong>.</li>
                    </ul>
                </div>
                
            </section>

            <section>
                <h3>Throughput</h3>
                <div>
                    <p>Adalah laju aktual bit data yang berhasil dipindahkan dari sender ke receiver (bits/sec).</p>
                    <ul>
                        <li><strong>Instantaneous:</strong> Throughput saat detik ini saja.</li>
                        <li><strong>Average:</strong> Rata-rata throughput dalam 1 sesi download.</li>
                        <li>Terhambat oleh link paling lemah/sempit di jalur tersebut (disebut <strong>Bottleneck Link</strong>).</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s7$qa$, $qa$jarkom-p1$qa$, $qa$1.5 Protocol Layers & Service Models$qa$, $qa$</section>

            <section>
                <h3>Mengapa Arsitektur Berlapis?</h3>
                <div>
                    <p>Jaringan adalah sistem raksasa. Layering memberikan keuntungan:</p>
                    <ul>
                        <li><strong>Modularitas:</strong> Mudah merawat dan mengubah satu bagian tanpa mengganggu bagian
                            lain. (Contoh: Mengganti kabel tembaga jadi fiber, tidak membuat aplikasi browser error).
                        </li>
                        <li><strong>Struktur Diskusi:</strong> Mudah memisahkan fungsi kompleks menjadi tugas spesifik
                            per layer.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Model OSI (Open Systems Interconnection)</h3>
                <div>
                    <p>Dirilis oleh ISO tahun 1984, Model OSI membagi jaringan menjadi 7 layer untuk standar komunikasi:
                    </p>
                    <ol>
                        <li><strong>Application:</strong> Antarmuka aplikasi jaringan.</li>
                        <li><strong>Presentation:</strong> Format data, enkripsi, kompresi.</li>
                        <li><strong>Session:</strong> Sinkronisasi dan manajemen sesi.</li>
                        <li><strong>Transport:</strong> Pengiriman ujung-ke-ujung yang handal.</li>
                        <li><strong>Network:</strong> Pengalamatan logis (IP) dan routing.</li>
                        <li><strong>Data Link:</strong> Pengalamatan fisik (MAC) dan transfer node-to-node.</li>
                        <li><strong>Physical:</strong> Sinyal fisik dan media kabel/nirkabel.</li>
                    </ol>
                </div>
            </section>

            <section>
                <h3>The Internet Protocol Stack (TCP/IP)</h3>
                <div>
                    <p>Berbeda dengan OSI, standar yang paling banyak digunakan di internet saat ini adalah TCP/IP (5
                        layer):</p>
                    <ul>
                        <li><strong>5. Application:</strong> (Menggabungkan Application, Presentation, Session OSI).
                            Layanan HTTP, SMTP. Pesan: <em>Message</em>.</li>
                        <li><strong>4. Transport:</strong> Transfer data antar aplikasi (TCP, UDP). Pesan:
                            <em>Segment</em>.
                        </li>
                        <li><strong>3. Network:</strong> Routing alamat IP global. Pesan: <em>Datagram</em>.</li>
                        <li><strong>2. Link:</strong> Transfer data ke tetangga dekat. Pesan: <em>Frame</em>.</li>
                        <li><strong>1. Physical:</strong> Pergerakan gelombang/sinyal. Pesan: <em>Bits</em>.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>Perbandingan Model OSI & TCP/IP</h3>
                <div>
                    
                    <div>
                        <h4>OSI Model</h4>
                        <div>
                            7. Application</div>
                        <div>
                            6. Presentation</div>
                        <div>
                            5. Session</div>
                        <div>
                            4. Transport</div>
                        <div>
                            3. Network</div>
                        <div>
                            2. Data Link</div>
                        <div>
                            1. Physical</div>
                    </div>
                    
                    <div>
                        <h4>TCP/IP Model</h4>
                        <div>
                            5. Application</div>
                        <div>
                            4. Transport</div>
                        <div>
                            3. Network</div>
                        <div>
                            2. Link</div>
                        <div>
                            1. Physical</div>
                    </div>
                </div>
            </section>

            <section>
                <h3>Proses Enkapsulasi (Bungkus Membungkus)</h3>
                <div>
                    <ul>
                        <li><strong>Encapsulation:</strong> Saat pesan dikirim turun ke physical layer, tiap layer akan
                            menambahkan informasi kontrol miliknya ke bagian depan data (disebut <em>Header</em>).</li>
                        <li><strong>Decapsulation:</strong> Di komputer tujuan, data naik ke atas. Tiap layer membaca
                            headernya, lalu membuang header tersebut sebelum memberikannya ke layer atas.</li>
                    </ul>
                    
            </section>

            
            <section>$qa$, 7) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s8$qa$, $qa$jarkom-p1$qa$, $qa$1.6 Pengantar Keamanan Jaringan$qa$, $qa$</section>

            <section>
                <h3>Malware</h3>
                <div>
                    <p>Malware (Perangkat Lunak Jahat) dapat menginfeksi host untuk mencuri data atau menjadikannya
                        mesin penyerang botnet.</p>
                    <ul>
                        <li><strong>Virus:</strong> Malware yang butuh interaksi Anda untuk aktif (misal klik lampiran
                            email).</li>
                        <li><strong>Worms:</strong> Malware pintar yang bisa menyebar otomatis lewat kelemahan jaringan
                            tanpa perlu diklik.</li>
                    </ul>
                </div>
            </section>

            <section>
                <h3>DoS dan DDoS Attacks</h3>
                <div>
                    <ul>
                        <li><strong>DoS (Denial of Service):</strong> Menyerang server dengan
                            banjir trafik sampah, sehingga memori/bandwith server penuh dan website lumpuh (tidak bisa
                            diakses pengguna asli).</li>
                        <li><strong>DDoS (Distributed DoS):</strong> Serangan DoS tapi
                            dilakukan secara keroyokan oleh puluhan ribu komputer <em>botnet</em> bajakan dari seluruh
                            dunia. Sangat sulit ditangkal.</li>
                    </ul>
                </div>
                <div>
                    <img src="https://informatika-itera.github.io/jarkom/img/chapter1/image99.jpeg" alt="DDoS Attack">
                </div>
            </section>

            <section>
                <h3>Sniffing dan Spoofing</h3>
                <div>
                    <ul>
                        <li><strong>Packet Sniffing:</strong> Penjahat "menguping" dan merekam
                            paket yang lalu lalang di Wi-Fi publik. Solusinya: Enkripsi data.</li>
                        <li><strong>IP Spoofing:</strong> Penjahat memalsukan alamat IP pengirim
                            di paketnya, sehingga seolah-olah paket berasal dari komputer tepercaya (teman/bank).</li>
                    </ul>
                </div>
            </section>

            <section>$qa$, 8) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p1-s9$qa$, $qa$jarkom-p1$qa$, $qa$1.7 Sejarah Singkat Jaringan$qa$, $qa$<div>
                    <ul>
                        <li><strong>1961-1972:</strong> Era ARPAnet, konsep Packet Switching lahir menggantikan monopoli
                            telepon Circuit Switching.</li>
                        <li><strong>1972-1990:</strong> Protokol TCP/IP dibakukan.</li>
                        <li><strong>1990-an:</strong> Tim Berners-Lee menemukan <em>World Wide Web</em> (Web dan HTML).
                            Mengubah internet menjadi industri raksasa komersial.</li>
                    </ul>
                </div>
            </section>

            
            <section>
                <h3>Rangkuman Pertemuan 1</h3>
                <div>
                    <ul>
                        <li>Internet ("Network of Networks") mendasari revolusi komunikasi global.</li>
                        <li>Infrastrukturnya: End Systems, Edge Router, Communication Links, Core Router.</li>
                        <li>Packet Switching memenangkan pertarungan melawan Circuit Switching.</li>
                        <li>Kinerja diukur dengan Delay, Loss, dan Throughput.</li>
                        <li>Arsitektur berlapis (TCP/IP) mempermudah rekayasa jaringan.</li>
                    </ul>
                </div>
            </section>

            
            <section>$qa$, 9) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-c1$qa$, $qa$jarkom-p1$qa$, $qa$checkpoint$qa$, $qa$Apa fungsi utama jaringan komputer?$qa$, $qa$["Menjalankan aplikasi berat", "Menghubungkan perangkat agar bisa bertukar data dan berbagi sumber daya", "Menggantikan sistem operasi", "Mempercepat prosesor"]$qa$::jsonb, 1, $qa$Jaringan menghubungkan perangkat untuk komunikasi data dan berbagi sumber daya.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-c2$qa$, $qa$jarkom-p1$qa$, $qa$checkpoint$qa$, $qa$Pada packet switching, data dikirim dengan cara...$qa$, $qa$["Satu jalur eksklusif dibuka selama sesi", "Dipecah jadi paket-paket yang bisa lewat jalur berbeda", "Dikirim analog tanpa alamat", "Ditahan sampai jalur kosong total"]$qa$::jsonb, 1, $qa$Packet switching memecah data menjadi paket yang dirutekan mandiri.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-c3$qa$, $qa$jarkom-p1$qa$, $qa$checkpoint$qa$, $qa$Protokol dalam jaringan komputer adalah...$qa$, $qa$["Perangkat keras penghubung kabel", "Aturan komunikasi yang disepakati antar perangkat", "Nama lain kabel UTP", "Program antivirus"]$qa$::jsonb, 1, $qa$Protokol adalah seperangkat aturan agar perangkat bisa saling memahami.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-b1$qa$, $qa$jarkom-p1$qa$, $qa$battle$qa$, $qa$Mengapa internet modern memilih packet switching daripada circuit switching?$qa$, $qa$["Karena packet switching mengalokasikan jalur eksklusif sehingga tidak ada antrean", "Karena trafik internet bersifat bursty sehingga berbagi resource jauh lebih efisien", "Karena packet switching menjamin delay nol untuk semua paket", "Karena circuit switching tidak bisa membawa data digital"]$qa$::jsonb, 1, $qa$Trafik internet bursty (diam lama, tiba-tiba butuh besar) sehingga berbagi kabel via paket jauh lebih efisien dan murah; kelemahannya adalah congestion saat padat.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-b2$qa$, $qa$jarkom-p1$qa$, $qa$battle$qa$, $qa$Router menerima paket lalu mencocokkan IP tujuannya dengan forwarding table untuk memilih link keluaran. Fungsi ini disebut...$qa$, $qa$["Routing", "Forwarding", "Multiplexing", "Encapsulation"]$qa$::jsonb, 1, $qa$Forwarding adalah aksi lokal memindahkan paket dari input ke output link; routing adalah proses global menentukan rute dan meng-update tabel.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-b3$qa$, $qa$jarkom-p1$qa$, $qa$battle$qa$, $qa$Paket 12.000 bit dikirim lewat link 3 Mbps. Waktu yang dibutuhkan untuk mendorong seluruh bit paket ke dalam kabel disebut...$qa$, $qa$["Propagation delay", "Transmission delay", "Queuing delay", "Processing delay"]$qa$::jsonb, 1, $qa$Transmission delay = L/R (panjang paket dibagi bandwidth); propagation delay tergantung jarak fisik, bukan ukuran paket.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-b4$qa$, $qa$jarkom-p1$qa$, $qa$battle$qa$, $qa$Throughput sebuah koneksi download tidak pernah melebihi 20 Mbps meski langganan 100 Mbps. Penyebab paling mungkin adalah...$qa$, $qa$["Bottleneck link di jalur tersebut", "Packet switching yang dipakai ISP", "Protokol TCP yang terlalu lambat", "Topologi star di rumah pelanggan"]$qa$::jsonb, 0, $qa$Throughput dibatasi link tersempit (bottleneck) di sepanjang jalur end-to-end.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p1-b5$qa$, $qa$jarkom-p1$qa$, $qa$battle$qa$, $qa$Manakah pernyataan yang TEPAT tentang protokol?$qa$, $qa$["Protokol hanya mengatur kecepatan transfer data", "Protokol mendefinisikan format dan urutan pesan serta tindakan saat mengirim dan menerima", "Protokol adalah perangkat keras penghubung antar jaringan", "Protokol hanya berlaku untuk jaringan nirkabel"]$qa$::jsonb, 1, $qa$Tanpa protokol yang disepakati, bit yang diterima penerima hanyalah kumpulan bit tanpa makna.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
