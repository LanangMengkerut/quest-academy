insert into public.stages (id, course_id, title, summary, source_url, source_label, sort_order) values ($qa$jarkom-p3$qa$, $qa$jarkom$qa$, $qa$Lapisan Fisik & Cabling$qa$, $qa$<h3>Data vs Sinyal</h3>
<p><strong>Data</strong> adalah informasi (bit 0/1); <strong>sinyal</strong> adalah representasi fisiknya agar bisa merambat — kabel LAN memindahkan voltase, bukan file.</p>
<ul>
<li><strong>Analog:</strong> kontinu & mulus (amplitudo, frekuensi, phase). Contoh: suara, radio FM.</li>
<li><strong>Digital:</strong> diskrit, hanya dua level (mis. +5V = 1, 0V = 0).</li>
<li><strong>Modulasi:</strong> menumpangkan data digital ke sinyal pembawa analog agar tahan jarak jauh; alatnya <strong>modem</strong> (modulasi + demodulasi).</li>
</ul>
<h3>Gangguan Transmisi</h3>
<ul>
<li><strong>Attenuation (redaman):</strong> sinyal melemah seiring jarak (satuan dB); solusi: repeater/amplifier. UTP efektif sekitar 100 m.</li>
<li><strong>Distortion:</strong> bentuk sinyal berubah karena komponen frekuensi tiba tak serentak.</li>
<li><strong>Noise:</strong> sinyal liar tak diinginkan (thermal, crosstalk, EMI).</li>
</ul>
<h3>Guided Media (Kabel)</h3>
<ul>
<li><strong>Coaxial:</strong> berlapis (inti tembaga, isolator, shield logam) sehingga tahan noise; konektor BNC; untuk TV kabel & CCTV.</li>
<li><strong>Twisted pair:</strong> pilinan kawat menangkal interferensi. <strong>UTP</strong> murah & lentur (standar LAN); <strong>STP</strong> berpelindung logam untuk lingkungan industri. Kategori: Cat 5e (1 Gbps) ekonomis, Cat 6/6a (10 Gbps).</li>
<li><strong>Susunan warna RJ45 568-B:</strong> Putih-Oranye, Oranye, Putih-Hijau, Biru, Putih-Biru, Hijau, Putih-Coklat, Coklat — ingat pasangan hijau dipisah pasangan biru (pin 3 & 6).</li>
<li><strong>Straight-through:</strong> kedua ujung sama (perangkat beda jenis: PC ke switch). <strong>Crossover:</strong> satu ujung 568-A, satu 568-B (perangkat sejenis: PC ke PC, switch ke switch).</li>
<li><strong>Fiber optik:</strong> inti kaca (core) + cladding pemantul cahaya. <strong>Single-mode</strong> (inti sekitar 8 mikrometer, puluhan km, backbone) vs <strong>multi-mode</strong> (inti sekitar 50 mikrometer, maks sekitar 500 m). Kelebihan: bandwidth masif, redaman kecil, 100 persen kebal EMI.</li>
</ul>
<h3>Unguided Media (Nirkabel)</h3>
<table>
<tr><th>Jenis</th><th>Frekuensi</th><th>Sifat</th><th>Contoh</th></tr>
<tr><td>Radio</td><td>3 Hz - 1 GHz</td><td>Omnidirectional, tembus tembok</td><td>FM/AM, Bluetooth, HT</td></tr>
<tr><td>Microwave</td><td>1 - 300 GHz</td><td>Unidirectional, butuh line-of-sight</td><td>Wi-Fi, BTS 4G/5G, backhaul</td></tr>
<tr><td>Infrared</td><td>300 GHz - 400 THz</td><td>Jarak di bawah 1 m, LoS ketat</td><td>Remote TV/AC, sensor PIR</td></tr>
<tr><td>Satelit</td><td>1 - 40 GHz</td><td>Cakupan global, latensi tinggi (GEO)</td><td>GPS, Starlink, VSAT</td></tr>
</table>
<p><strong>Aturan emas:</strong> semakin tinggi frekuensi, semakin besar bandwidth tetapi semakin pendek jangkauan dan mudah terhalang.</p>$qa$, $qa$https://informatika-itera.github.io/jarkom/pertemuan03.html$qa$, $qa$MATERI ASLI — WEB ITERA$qa$, 3) on conflict (id) do update set course_id = excluded.course_id, title = excluded.title, summary = excluded.summary, source_url = excluded.source_url, source_label = excluded.source_label, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s1$qa$, $qa$jarkom-p3$qa$, $qa$Lapisan Fisik & Cabling$qa$, $qa$<div>
        <div>
            <div></div>
            <div>&copy; 2026 IF25-21008 Jaringan Komputer - ITERA</div>
        </div>

        <div>

            
            <section>
                <div>
                    
                    <h3>Pertemuan 3</h3>
                </div>
                <p>Referensi Utama: Forouzan &mdash; <em>Data Communications and Networking</em></p>
                <p><em>Dosen Pengampu:</em></p>
                <div>
                    <div><i></i> Rajif Agung Yunmar, S.Kom., M.Cs.</div>
                    <div><i></i> I Wayan Wiprayoga Wisesa, S.Kom., M.Kom.</div>
                    <div><i></i> Hartanto Tantriawan, S.Kom., M.Kom.</div>
                    <div><i></i> Ilham Firman Ashari, S.Kom., M.T.</div>
                </div>
                <aside>Selamat pagi/siang. Hari ini kita turun ke lapisan terbawah dari model OSI, yaitu
                    Physical Layer.</aside>
            </section>

            
            <section>
                <h3>Outline Materi</h3>
                <div>
                    <ol>
                        <li>Konsep Sinyal: Analog vs Digital</li>
                        <li>Gangguan Transmisi</li>
                        <li>Guided Media:
                            <ol>
                                <li>Coaxial</li>
                                <li>Twisted Pair</li>
                                <li>Fiber Optik</li>
                            </ol>
                        </li>
                        <li>Unguided Media:
                            <ol>
                                <li>Radio</li>
                                <li>Microwave</li>
                                <li>Infrared</li>
                                <li>Satelit</li>
                            </ol>
                        </li>
                    </ol>
                </div>
            </section>

            
            <section>$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s2$qa$, $qa$jarkom-p3$qa$, $qa$1. Konsep Sinyal & Transmisi$qa$, $qa$<aside>Sebelum membahas kabel, kita harus tahu apa wujud data yang mengalir di dalamnya.
                </aside>
            </section>

            
            <section>
                <h3>Data vs Sinyal</h3>
                <div>
                    <div>
                        <ul>
                            <li><strong>Data:</strong> Entitas yang mengandung informasi (teks, gambar, video). Komputer
                                menyimpannya sebagai bit 0 dan 1.</li>
                            <li><strong>Sinyal:</strong> Representasi elektrik/elektromagnetik
                                dari data, agar bisa merambat secara fisik melalui kabel atau udara.</li>
                        </ul>
                        <div>
                            &#x1F4A1; Kabel LAN tidak memindahkan file video secara langsung. Kabel LAN memindahkan
                            <strong>voltase listrik</strong> yang merepresentasikan setiap bit dari file tersebut.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image6.png" alt="Diagram Sistem Transmisi: Transmitter - Channel - Receiver">
                        <p>Sistem transmisi dasar</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Sinyal Analog</h3>
                <div>
                    <div>
                        <div>Apa itu Sinyal Analog?</div>
                        <div>
                            <ul>
                                <li>Intensitas (voltase) berubah secara <strong>kontinu dan mulus</strong> seiring waktu
                                    &mdash; tidak ada lompatan mendadak.</li>
                                <li>Digambarkan sebagai gelombang sinus yang meliuk-liuk.</li>
                                <li>Tiga parameter utama: <strong>Amplitudo</strong> (kekuatan),
                                    <strong>Frekuensi</strong> (kecepatan gelombang), <strong>Phase</strong> (posisi
                                    awal gelombang).
                                </li>
                            </ul>
                        </div>
                        <div>
                            <strong>Contoh nyata:</strong> Suara manusia di udara, siaran radio FM, sinyal telepon kabel
                            generasi lama.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/sinyal_analog_pro.jpg" alt="Gelombang analog: kontinu dan mulus">
                        <p>Gelombang analog &mdash; kontinu &amp; mulus</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Sinyal Digital</h3>
                <div>
                    <div>
                        <div>Karakteristik Sinyal Digital</div>
                        <div>
                            <ul>
                                <li>Hanya memiliki nilai <strong>diskrit yang terbatas</strong> &mdash; biasanya dua
                                    level: tinggi dan rendah.</li>
                                <li>Bentuk gelombang: persegi (kotak-kotak, patah tajam).</li>
                                <li>Representasi biner langsung:<br>
                                    &nbsp;&nbsp;&#x2022; <strong>+5 Volt = bit 1</strong><br>
                                    &nbsp;&nbsp;&#x2022; <strong>0 Volt = bit 0</strong>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/sinyal_digital_id.jpg" alt="Sinyal digital diskrit">
                        <p>Gelombang digital &mdash; diskrit (kotak-kotak)</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Modulasi (Mo-Dem)</h3>
                <div>
                    <div>
                        <div>Konsep Modulasi</div>
                        <div>
                            <ul>
                                <li>Proses <strong>menumpangkan</strong> data digital ke atas sinyal analog pembawa
                                    (<em>carrier signal</em>).</li>
                                <li>Diperlukan agar sinyal bisa dikirim jarak jauh (4G, satelit, ADSL).</li>
                                <li>Alat yang melakukan modulasi (digital&#x2192;analog) dan demodulasi
                                    (analog&#x2192;digital) disebut <strong>Modem</strong>.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/modulasi_id.jpg" alt="Proses Modulasi">
                        <p>Proses penumpangan data digital ke sinyal analog</p>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s3$qa$, $qa$jarkom-p3$qa$, $qa$2. Gangguan Transmisi (Impairment)$qa$, $qa$<aside>Sinyal yang dikirim tidak pernah sampai persis sama. Ada 3 jenis gangguan utama.
                </aside>
            </section>

            
            <section>
                <h3>Tiga Jenis Gangguan Transmisi</h3>
                <div>
                    <div>
                        <p>Sinyal yang dikirim dari titik A <strong>tidak pernah</strong> tiba 100% identik di titik B.
                            Selalu ada degradasi akibat tiga faktor:</p>
                        <ol>
                            <li><strong>Attenuation (Redaman)</strong>
                                &mdash; sinyal kehilangan energi dan melemah.</li>
                            <li><strong>Distortion
                                    (Distorsi)</strong> &mdash; bentuk sinyal berubah dari aslinya.</li>
                            <li><strong>Noise (Kebisingan)</strong> &mdash; sinyal liar tak
                                diinginkan bercampur.</li>
                        </ol>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/gangguan_transmisi_id.jpg" alt="Diagram tiga jenis gangguan transmisi">
                        <p>Ilustrasi redaman, distorsi, dan noise</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Attenuation (Redaman)</h3>
                <div>
                    <div>
                        <div>Konsep Attenuation</div>
                        <div>
                            <ul>
                                <li>Kehilangan energi &mdash; sinyal melemah seiring bertambahnya jarak.</li>
                                <li>Terjadi karena <strong>resistansi kabel</strong> mengubah energi listrik menjadi
                                    panas.</li>
                                <li>Diukur dalam satuan <strong>Decibel (dB)</strong>.</li>
                                <li><strong>Solusi:</strong> Repeater atau Amplifier dipasang di tengah jalur.</li>
                            </ul>
                        </div>
                        <div>
                            &#x26A0;&#xFE0F; Kabel UTP standar hanya efektif hingga <strong>100 meter</strong>. Lebih
                            dari itu butuh repeater!
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/attenuation_id.jpg" alt="Proses redaman sinyal dan repeater">
                        <p>Redaman seiring jarak dan fungsi repeater</p>
                    </div>
                </div>
                <aside>Analogi attenuation: berbicara keras di ujung lorong, suaranya makin jauh makin
                    pelan.</aside>
            </section>

            
            <section>
                <h3>Distortion (Distorsi)</h3>
                <div>
                    <div>
                        <div>Konsep Distortion</div>
                        <div>
                            <ul>
                                <li>Perubahan <strong>bentuk</strong> sinyal dari aslinya &mdash; bukan sekadar melemah.
                                </li>
                                <li>Terjadi paling sering pada sinyal komposit (gabungan banyak frekuensi).</li>
                                <li>Setiap komponen frekuensi merambat dengan kecepatan sedikit berbeda di dalam medium.
                                </li>
                                <li>Akibatnya, komponen-komponen tersebut tiba di tujuan pada waktu yang tidak serentak.
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/distortion_id.jpg" alt="Proses distorsi karena perbedaan kecepatan rambat frekuensi">
                        <p>Perubahan bentuk sinyal komposit karena distorsi</p>
                    </div>
                </div>
                <aside>Analogi distortion: orkestra yang instrumennya tiba pada waktu berbeda sehingga
                    suaranya jadi kacau.</aside>
            </section>

            
            <section>
                <h3>Noise (Kebisingan / Gangguan)</h3>
                <div>
                    <div>
                        <p>Sinyal tambahan liar yang tidak diinginkan, bercampur dengan sinyal asli sehingga mengubah
                            isi informasi.</p>
                        <p>Tiga jenis noise paling umum:</p>
                        <ul>
                            <li><strong>Crosstalk:</strong> Efek induksi elektromagnetik dari kabel lain yang
                                berdekatan. Penyebab utama inilah yang membuat kabel UTP <em>dipilin</em> &mdash; untuk
                                membatalkan efek crosstalk.</li>
                            <li><strong>Thermal Noise:</strong> Pergerakan acak elektron dalam konduktor akibat suhu
                                ruangan. Tidak bisa dihilangkan sepenuhnya.</li>
                            <li><strong>EMI:</strong> Gangguan dari sumber eksternal seperti motor listrik, microwave
                                oven, atau petir.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/noise_id.jpg" alt="Ilustrasi Crosstalk, Thermal Noise, dan EMI">
                        <p>Ilustrasi tiga jenis gangguan noise</p>
                        <div>
                            &#x1F4A1; <strong>SNR</strong> = rasio kekuatan sinyal vs noise. Makin tinggi SNR, makin
                            bersih sinyal.
                        </div>
                    </div>
                </div>
            </section>

            
            <section>$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s4$qa$, $qa$jarkom-p3$qa$, $qa$3. Media Transmisi$qa$, $qa$<p>Jalan Raya Bagi Sinyal</p>
                <aside>Kita bahas dua kategori besar: Guided (kabel) dan Unguided (nirkabel).</aside>
            </section>

            
            <section>
                <h3>Guided vs Unguided Media</h3>
                <div>
                    <div>
                        <ul>
                            <li><strong>Guided Media (Kabel):</strong> Sinyal "dipandu" di dalam
                                medium padat dari ujung ke ujung.<br>
                                <em>Contoh: Twisted Pair, Coaxial, Fiber Optik.</em>
                            </li>
                            <li><strong>Unguided Media
                                    (Nirkabel):</strong> Gelombang elektromagnetik merambat bebas di udara atau ruang
                                hampa tanpa panduan fisik.<br>
                                <em>Contoh: Wi-Fi, BTS Seluler, Satelit.</em>
                            </li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image8.png" alt="Klasifikasi Transmission Media">
                        <p>Klasifikasi media transmisi</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Guided 1: Coaxial Cable &mdash; Struktur</h3>
                <div>
                    <div>
                        <p>Kabel koaksial memiliki konstruksi berlapis yang menjadikannya sangat tahan noise:</p>
                        <ol>
                            <li><strong>Centre Core</strong> &mdash; kawat tembaga solid sebagai penghantar sinyal
                                utama.</li>
                            <li><strong>Dielectric Insulator</strong> &mdash; isolator plastik tebal memisahkan inti
                                dari shield.</li>
                            <li><strong>Metallic Shield</strong> &mdash; jaring anyaman logam atau foil aluminium
                                pelindung EMI sekaligus penghantar balik.</li>
                            <li><strong>Plastic Jacket</strong> &mdash; pembungkus luar untuk proteksi fisik.</li>
                        </ol>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image10.png" alt="Diagram penampang kabel coaxial">
                        <p>Penampang kabel koaksial</p>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image11.png" alt="Foto fisik kabel coaxial dikupas">
                        <p>Fisik kabel koaksial dikupas</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Guided 1: Coaxial Cable &mdash; Karakteristik &amp; Penggunaan</h3>
                <div>
                    <div>
                        <div>Karakteristik Teknis</div>
                        <div>
                            <ul>
                                <li>Frekuensi kerja: <strong>100 kHz &ndash; 500 MHz</strong> (jauh lebih tinggi dari
                                    UTP).</li>
                                <li>Bandwidth besar &mdash; cocok untuk sinyal video frekuensi tinggi.</li>
                                <li>Konstruksi kaku &mdash; tidak mudah ditekuk berkali-kali.</li>
                                <li>Konektor: <strong>BNC</strong> (Bayonet Neill&ndash;Concelman) &mdash; twist-lock,
                                    tidak mudah lepas.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Penggunaan Utama</div>
                        <div>
                            <ul>
                                <li>&#x1F4FA; <strong>TV Kabel</strong> (FirstMedia, MNC Play) &mdash; distribusi sinyal
                                    dari head-end ke rumah.</li>
                                <li>&#x1F4F7; <strong>CCTV Analog</strong> &mdash; kabel RG-59/RG-6 menghubungkan kamera
                                    ke DVR.</li>
                                <li>&#x1F50C; <strong>LAN 10Base2/10Base5</strong> &mdash; teknologi jaringan lawas
                                    1980&ndash;1990-an.</li>
                                <li>&#x1F4E1; <strong>Antena TV/Radio</strong> &mdash; menghubungkan antena atap ke TV.
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Guided 2: Twisted-Pair Cable &mdash; Konsep</h3>
                <div>
                    <div>
                        <ul>
                            <li>Terdiri dari <strong>dua konduktor tembaga</strong>, masing-masing dibungkus isolator
                                plastik, lalu <strong>dipilin (di-twist) bersama</strong>.</li>
                            <li><strong>Mengapa harus dipilin?</strong><br>
                                Pilinan menciptakan medan magnet yang saling berlawanan pada kedua kawat. Saat noise EMI
                                datang, efeknya terbatalkan secara alami (<em>differential signaling</em>).
                            </li>
                            <li>Semakin rapat pilinan per meter &#x2192; semakin kebal terhadap
                                EMI, tapi semakin mahal.</li>
                        </ul>
                        <div>
                            &#x1F4A1; Inilah alasan kenapa ketika Anda buka kabel LAN, isi dalamnya selalu berpilin
                            &mdash; bukan karena estetika!
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image20.png" alt="Penampang kabel UTP dan STP">
                        <p>Penampang UTP (atas) &amp; STP (bawah)</p>
                    </div>
                </div>
                <aside>Jika ditanya di ujian kenapa dipilin: untuk membatalkan gelombang induksi EMI
                    &mdash; noise saling menghapuskan satu sama lain.</aside>
            </section>

            
            <section>
                <h3>Guided 2: UTP vs STP</h3>
                <div>
                    <div>
                        <div>UTP &mdash; Unshielded Twisted Pair</div>
                        <div>
                            <ul>
                                <li>Tidak memiliki pelindung logam tambahan &mdash; hanya pilinan kawat.</li>
                                <li>Paling <strong>murah dan lentur</strong> &mdash; mudah dipasang di berbagai sudut
                                    gedung.</li>
                                <li>Standar de-facto jaringan LAN di seluruh dunia (rumah, kantor, kampus).</li>
                                <li>Rentan terhadap EMI di lingkungan industri berat.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>STP &mdash; Shielded Twisted Pair</div>
                        <div>
                            <ul>
                                <li>Memiliki lapisan <strong>metal braid / aluminium foil</strong> tambahan yang
                                    membungkus keempat pasang kawat.</li>
                                <li>Memberikan kekebalan ekstra terhadap EMI yang ekstrem.</li>
                                <li>Digunakan di lingkungan industri, pabrik, atau area dekat tiang listrik tegangan
                                    tinggi.</li>
                                <li>Lebih mahal, lebih kaku, dan memerlukan ground yang benar agar efektif.</li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div>
                    <img src="https://informatika-itera.github.io/jarkom/img/week3/image21.png" alt="Perbandingan fisik kabel UTP dan STP">
                    <p>UTP vs STP</p>
                </div>
            </section>

            
            <section>
                <h3>Kategori Kabel UTP</h3>
                <div>
                    <table>
                        <tr>
                            <th>Kategori</th>
                            <th>Max Bandwidth</th>
                            <th>Max Data Rate</th>
                            <th>Penggunaan</th>
                        </tr>
                        <tr>
                            <td>Cat 3</td>
                            <td>16 MHz</td>
                            <td>10 Mbps</td>
                            <td>Telepon analog, LAN 10Base-T (usang)</td>
                        </tr>
                        <tr>
                            <td>Cat 5</td>
                            <td>100 MHz</td>
                            <td>100 Mbps</td>
                            <td>Fast Ethernet (usang)</td>
                        </tr>
                        <tr>
                            <td><strong>Cat 5e</strong></td>
                            <td>100 MHz</td>
                            <td><strong>1 Gbps</strong></td>
                            <td>Standar LAN rumah / kantor kecil. Maks 100m.</td>
                        </tr>
                        <tr>
                            <td><strong>Cat 6</strong></td>
                            <td>250 MHz</td>
                            <td><strong>10 Gbps</strong> (55m)</td>
                            <td>LAN perkantoran modern. Ada spline plastik di tengah.</td>
                        </tr>
                        <tr>
                            <td><strong>Cat 6a</strong></td>
                            <td>500 MHz</td>
                            <td><strong>10 Gbps</strong> (100m)</td>
                            <td>Data Center / Backbone LAN. Lebih tebal &amp; berat.</td>
                        </tr>
                        <tr>
                            <td>Cat 7</td>
                            <td>600 MHz</td>
                            <td>10 Gbps+</td>
                            <td>High-density Data Center (konektor GG45).</td>
                        </tr>
                    </table>
                </div>
                <div>
                    &#x1F4A1; <strong>Cat 5e</strong> adalah pilihan paling ekonomis untuk jaringan rumah/kantor.
                    <strong>Cat 6</strong> untuk performa lebih tinggi dengan anggaran sedang.
                </div>
            </section>

            
            <section>
                <h3>Konektor RJ45 &amp; Susunan Warna 568-B</h3>
                <div>
                    <div>
                        <p><strong>RJ45</strong> (Registered Jack 45) adalah konektor plastik transparan dengan
                            <strong>8 pin tembaga</strong> yang menjadi standar kabel UTP.
                        </p>
                        <p>Susunan warna TIA/EIA 568-B (paling populer di
                            Indonesia):</p>
                        <p>Pin 1&#x2192;8, klip RJ45 menghadap ke bawah:</p>
                        <ol>
                            <li><span>Putih-Oranye</span></li>
                            <li><span>Oranye</span></li>
                            <li><span>Putih-Hijau</span></li>
                            <li><span>Biru</span></li>
                            <li><span>Putih-Biru</span></li>
                            <li><span>Hijau</span></li>
                            <li><span>Putih-Coklat</span></li>
                            <li><span>Coklat</span></li>
                        </ol>
                        <div>
                            &#x26A0;&#xFE0F; Ingat: pasangan Hijau dipisahkan oleh pasangan Biru (pin 3 &amp; 6 tidak
                            bersebelahan). Ini yang sering salah!
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image27.png" alt="Konektor RJ45 tampak depan 8 pin">
                        <p>Konektor RJ45 (8 pin tembaga)</p>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image28.png" alt="Jack RJ45 keystone">
                        <p>Jack RJ45 pada keystone panel</p>
                    </div>
                </div>
                <aside>Tips hafalan 568-B: Putih-Oranye, Oranye, Putih-Hijau, BIRU, Putih-Biru, Hijau,
                    Putih-Coklat, Coklat. Ingat pasangan hijau terpisah oleh biru.</aside>
            </section>

            
            <section>$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s5$qa$, $qa$jarkom-p3$qa$, $qa$Kabel UTP: Straight & Cross$qa$, $qa$<aside>Mari kita bahas dua jenis susunan kabel UTP yang sering digunakan: Straight-through
                    dan Crossover, beserta fungsinya masing-masing.</aside>
            </section>

            
            <section>
                <h3>Kabel UTP Straight-Through</h3>
                <div>
                    <div>
                        <div>Definisi &amp; Standar</div>
                        <div>
                            <p><strong>Straight-through cable</strong> adalah kabel UTP di mana kedua ujungnya memiliki
                                susunan warna pin yang <strong>sama</strong>. Biasanya menggunakan standar
                                <strong>TIA/EIA-568B</strong> di kedua ujungnya.
                            </p>
                        </div>
                        <div>Fungsi &amp;
                            Penggunaan</div>
                        <div>
                            <p>Digunakan untuk menghubungkan dua perangkat jaringan yang <strong>berbeda
                                    tingkat/jenis</strong>. Contoh: Komputer (PC/Laptop) ke Switch / Hub, Komputer ke
                                Router
                                (Port LAN), Switch ke Router.
                            </p>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image24.png" alt="Diagram pin Straight-Through Cable">
                        <p>Susunan Straight-Through (568-B ke 568-B)</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Kabel UTP Crossover</h3>
                <div>
                    <div>
                        <div>Definisi &amp; Standar</div>
                        <div>
                            <p><strong>Crossover cable</strong> adalah kabel UTP di mana salah satu ujung menggunakan
                                <strong>TIA/EIA-568A</strong> dan ujung lainnya <strong>TIA/EIA-568B</strong>. Terjadi
                                "persilangan" pada pin transmisi (Tx) dan penerima (Rx).
                            </p>
                        </div>
                        <div>Fungsi &amp;
                            Penggunaan</div>
                        <div>
                            <p>Digunakan untuk menghubungkan dua perangkat jaringan yang
                                <strong>setingkat/sejenis</strong>. Contoh: Komputer ke Komputer secara langsung, Switch
                                ke
                                Switch, Router ke Router.
                            </p>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image22.png" alt="Diagram pin Crossover Cable">
                        <p>Susunan Crossover (568-B ke 568-A)</p>
                    </div>
                </div>
                <aside>Catatan: Sebagian besar perangkat modern saat ini memiliki fitur Auto-MDIX yang
                    secara otomatis dapat menyesuaikan jika kita menggunakan kabel straight untuk perangkat yang
                    sejenis. Namun secara teori, pengkabelan crossover tetap penting untuk dipahami.</aside>
            </section>

            
            <section>
                <h3>Guided 3: Fiber Optik (Prinsip)</h3>
                <div>
                    <div>
                        <p>Fiber optik menghantarkan <strong>pulsa cahaya</strong> (bukan arus listrik) melalui inti
                            kaca/plastik silika berkualitas tinggi.</p>
                        <p>Prinsip kerja: Total Internal Reflection</p>
                        <p>Cahaya yang masuk ke inti fiber akan dipantulkan bolak-balik di
                            dinding kaca secara terus-menerus, tidak bocor keluar, hingga mencapai tujuan.</p>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/fiber_prinsip_id.jpg" alt="Pemantulan Internal Total pada Fiber Optik">
                        <p>Prinsip Pemantulan Internal Total</p>
                    </div>
                </div>
            </section>

            <section>
                <h3>Guided 3: Fiber Optik (Struktur)</h3>
                <div>
                    <div>
                        <p>Lapisan struktur fiber:</p>
                        <ol>
                            <li><strong>Core</strong> &mdash; inti kaca ultra-jernih, tempat cahaya merambat.</li>
                            <li><strong>Cladding</strong> &mdash; lapisan kaca dengan indeks refraksi lebih rendah,
                                memantulkan cahaya ke dalam core.</li>
                            <li><strong>Coating</strong> &mdash; pelindung plastik tipis dari goresan.</li>
                            <li><strong>Strength Member &amp; Outer Jacket</strong> &mdash; proteksi mekanis.</li>
                        </ol>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/image33.png" alt="Struktur 3D kabel Fiber Optik">
                        <p>Struktur kabel fiber optik</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Guided 3: Jenis Fiber Optik</h3>
                <div>
                    <div>
                        <div>Dua Jenis Fiber</div>
                        <div>
                            <ul>
                                <li><strong>Single-mode (SMF):</strong> Inti sangat kecil (~8 &micro;m). Cahaya merambat
                                    lurus tanpa pantulan. Jarak sangat jauh (puluhan&ndash;ratusan km). Dipakai untuk
                                    backbone internet &amp; backbone antar kota.</li>
                                <li><strong>Multi-mode (MMF):</strong> Inti lebih besar
                                    (~50&ndash;62.5 &micro;m). Cahaya merambat dalam banyak jalur (mode). Jarak lebih
                                    pendek (maks ~500m). Dipakai di data center &amp; LAN gedung.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>
                            <img src="https://informatika-itera.github.io/jarkom/img/week3/image34.png" alt="Single-mode vs Multi-mode fiber">
                            <p>Single-mode (atas) vs Multi-mode (bawah)</p>
                        </div>
                    </div>
                </div>
            </section>
            <section>
                <h3>Guided 3: Tulang Punggung Internet Global</h3>
                <div>
                    <div>
                        <ul>
                            <li>&#x1F30D; <strong>Kabel Bawah Laut (Submarine Cables):</strong> Fakta mengejutkan:
                                Sekitar <strong>99% data internet antar benua</strong> mengalir melalui kabel fiber
                                optik yang diletakkan di dasar samudera, bukan melalui satelit.</li>
                            <li>&#x1F4E1; <strong>Mengapa bukan Satelit?</strong> Satelit memiliki bandwidth yang jauh
                                lebih terbatas dan latensi yang lebih lambat (ratusan milidetik) dibandingkan fiber
                                optik yang mampu menghantarkan cahaya antar benua dalam puluhan milidetik.</li>
                            
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/submarine_cable_id.jpg" alt="Kabel Bawah Laut Fiber Optik">
                        <p>Ilustrasi jaringan kabel laut antar benua</p>
                    </div>
                </div>
            </section>
            <section>
                <h3>Guided 3: Kelebihan Fiber Optik</h3>
                <div>
                    <div>
                        <ul>
                            <li>&#x1F680; <strong>Bandwidth Masif:</strong> Ratusan Gbps hingga Terabit/s. Tulang
                                punggung internet global di bawah laut.</li>
                            <li>&#x1F4CF; <strong>Redaman Sangat Kecil:</strong> Kabel tembaga perlu repeater setiap
                                100m. Fiber optik bisa jalan puluhan km tanpa repeater.</li>
                            <li>&#x1F6E1;&#xFE0F; <strong>Kebal EMI 100%:</strong> Tidak pakai listrik &#x2192;
                                tidak tersambar petir, tidak terganggu mesin pabrik.</li>
                            
                            <li>&#x2696;&#xFE0F; <strong>Lebih Ringan &amp; Kecil:</strong> Satu kabel fiber bisa
                                menggantikan ribuan kabel tembaga.</li>
                        </ul>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/fiber_kelebihan_id.jpg" alt="Infografis Kelebihan Fiber Optik">
                        <p>4 Keunggulan Utama Fiber Optik</p>
                    </div>
                </div>
            </section>


            
            <section>$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.sections (id, stage_id, title, body, sort_order) values ($qa$jarkom-p3-s6$qa$, $qa$jarkom-p3$qa$, $qa$4. Unguided Media (Nirkabel)$qa$, $qa$<p>Gelombang elektromagnetik merambat bebas tanpa panduan fisik</p>
                <aside>Ada 4 jenis utama yang akan kita bahas satu per satu.</aside>
            </section>

            
            <section>
                <h3>Empat Jenis Unguided Media</h3>
                <div>
                    <div>
                        <div><i></i></div>
                        <h5>Gelombang Radio</h5>
                        <p>3 Hz &ndash; 1 GHz<br>Omnidirectional<br>Tembus tembok<br>FM, AM, Bluetooth</p>
                    </div>
                    <div>
                        <div><i></i></div>
                        <h5>Gelombang Mikro</h5>
                        <p>1 &ndash; 300 GHz<br>Unidirectional<br>Line-of-Sight<br>BTS, Wi-Fi, Backhaul</p>
                    </div>
                    <div>
                        <div><i></i></div>
                        <h5>Infrared</h5>
                        <p>300 GHz &ndash; 400 THz<br>Jarak &lt; 1 m<br>Tidak tembus dinding<br>Remote TV, IrDA</p>
                    </div>
                    <div>
                        <div><i></i></div>
                        <h5>Satelit</h5>
                        <p>Jangkauan global<br>Latensi tinggi (GEO)<br>Area terpencil<br>GPS, Starlink, VSAT</p>
                    </div>
                </div>
                <div>
                    &#x1F511; Semakin tinggi frekuensi &#x2192; <strong>bandwidth lebih besar</strong>, tapi
                    <strong>jangkauan lebih pendek</strong> dan semakin mudah terhalang benda padat.
                </div>
                <div>
                    &#x26A0;&#xFE0F; <strong>Catatan Wi-Fi:</strong> Berdasarkan taksonomi Forouzan (referensi utama), Wi-Fi masuk kategori <em>Microwave (Unidirectional)</em> karena beroperasi di band 2.4/5 GHz. Namun pada kenyataan praktis (referensi Tanenbaum &amp; Kurose), perangkat Wi-Fi rumahan memancarkan sinyal secara <strong>Omnidirectional</strong>.
                </div>
            </section>

            
            <section>
                <h3><i></i> Karakteristik Gelombang Radio</h3>
                <div>
                    <div>
                        <div>Sifat Fisik</div>
                        <div>
                            <ul>
                                <li><strong>Frekuensi:</strong> 3 Hz &ndash; 1 GHz. Mencakup sub-band: ELF, VLF, LF, MF
                                    (AM), HF, VHF, UHF.</li>
                                <li><strong>Arah Rambat:</strong> <em>Omnidirectional</em> &mdash; menyebar ke semua
                                    arah seperti cahaya bola lampu. Tidak butuh pengarahan antena.</li>
                                <li><strong>Penetrasi:</strong> Mampu menembus tembok beton, hujan, dan bukit kecil.
                                </li>
                                <li><strong>Panjang Gelombang:</strong> Panjang (meter hingga kilometer), sehingga tidak
                                    mudah diserap objek kecil.</li>
                            </ul>
                        </div>
                        
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/radio_wave_devices.png" alt="Transmisi gelombang radio: menara AM/FM ke rumah dan mobil">
                        <p>Transmisi gelombang radio AM/FM</p>
                    </div>
                </div>
            </section>

            <section>
                <h3><i></i> Kelemahan Gelombang Radio</h3>
                <div>
                    <div>
                        <div>
                            &#x26A0;&#xFE0F; Karena omnidirectional, sinyal radio mudah <strong>tersadap</strong> dan
                            rentan terhadap <strong>interferensi antar pemancar</strong> di frekuensi sama. Regulasi
                            frekuensi oleh pemerintah diperlukan.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/kelemahan_radio_id.jpg" alt="Ilustrasi penyadapan dan interferensi gelombang radio">
                        <p>Risiko penyadapan &amp; interferensi sinyal radio</p>
                    </div>
                </div>
            </section>


            
            <section>
                <h3><i></i> Gelombang Radio &mdash; Contoh Perangkat
                </h3>
                <div>
                    <div>
                        <p>Perangkat Penyiaran (Broadcasting)</p>
                        <ul>
                            <li>&#x1F4E1; <strong>Menara Pemancar AM/FM</strong> &mdash; siaran radio ke jutaan
                                pendengar sekaligus.</li>
                            <li>&#x1F4FA; <strong>Pemancar TV Analog/Digital</strong> (VHF/UHF) &mdash; siaran televisi
                                terrestrial.</li>
                            <li>&#x1F681; <strong>Radio Komunikasi Penerbangan</strong> &mdash; ATC menggunakan band VHF
                                118&ndash;137 MHz.</li>
                            <li>&#x1F692; <strong>HT (Handy Talky)</strong> &mdash; komunikasi darurat polisi, pemadam
                                kebakaran.</li>
                        </ul>
                    </div>
                    <div>
                        <p>Perangkat Jaringan Pendek</p>
                        <ul>
                            <li>&#x1F535; <strong>Bluetooth</strong> (2.4 GHz, ISM band) &mdash; headset, speaker,
                                transfer file jarak pendek (&lt; 10m standar).</li>
                            <li>&#x1F310; <strong>Zigbee &amp; Z-Wave</strong> (868 MHz / 2.4 GHz) &mdash; otomasi rumah
                                (smart home), sensor IoT.</li>
                            <li>&#x1F3AE; <strong>RF Remote</strong> &mdash; remote TV/AC generasi baru yang tidak butuh
                                LoS seperti infrared.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Gelombang Mikro &mdash; Karakteristik
                </h3>
                <div>
                    <div>
                        <div>Sifat Fisik</div>
                        <div>
                            <ul>
                                <li><strong>Frekuensi:</strong> 1 GHz &ndash; 300 GHz. Termasuk sub-band S, C, X, Ku,
                                    Ka.</li>
                                <li><strong>Arah Rambat:</strong> <em>Unidirectional</em> &mdash; terfokus seperti sinar
                                    laser. Antena parabola digunakan untuk memfokuskan sinyal.</li>
                                <li><strong>Syarat Line-of-Sight (LoS):</strong> Antena pengirim dan penerima <em>harus
                                        bisa saling melihat</em> &mdash; tidak boleh ada halangan gunung, gedung tinggi,
                                    atau pohon besar.</li>
                                <li><strong>Panjang Gelombang:</strong> Pendek (mm &ndash; cm). Mudah terserap oleh
                                    hujan lebat (<em>Rain Fade</em>).</li>
                            </ul>
                        </div>
                        <div>
                            &#x26A0;&#xFE0F; Karena memerlukan LoS, tower BTS harus ditempatkan di titik-titik tinggi
                            dengan radius yang cermat &mdash; itulah alasan tower BTS sering di bukit atau atap gedung
                            tinggi.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/microwave_devices.png" alt="Perangkat gelombang mikro: BTS, WiFi, antena backhaul">
                        <p>Perangkat microwave: BTS, WiFi, backhaul</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Gelombang Mikro &mdash; Contoh Perangkat
                </h3>
                <div>
                    <div>
                        <p>Komunikasi Seluler &amp; LAN</p>
                        <ul>
                            <li>&#x1F5FC; <strong>BTS (Base Transceiver Station)</strong> &mdash; menara seluler 4G LTE
                                / 5G NR. Menggunakan band 700 MHz &ndash; 26 GHz.</li>
                            <li>&#x1F4F6; <strong>Wi-Fi Router</strong> (2.4 GHz &amp; 5 GHz) &mdash; jaringan nirkabel
                                lokal di rumah/kantor/kampus (<em>praktiknya omnidirectional, walau secara akademis diklasifikasikan sebagai microwave di sini</em>).</li>
                            <li>&#x1F537; <strong>WiMAX</strong> (2.3&ndash;3.5 GHz) &mdash; broadband nirkabel jarak
                                menengah (beberapa km).</li>
                        </ul>
                    </div>
                    <div>
                        <p>Backhaul &amp; Point-to-Point</p>
                        <ul>
                            <li>&#x1F4E1; <strong>Antena Microwave Backhaul</strong> &mdash; menghubungkan BTS ke
                                jaringan inti. Dua antena parabola saling berhadapan antar gedung (jarak 1&ndash;50 km).
                            </li>
                            <li>&#x1F3E2; <strong>LMDS/MMDS</strong> &mdash; distribusi internet broadband ke kawasan
                                perumahan tanpa kabel.</li>
                            <li>&#x1F327;&#xFE0F; <strong>Radar Cuaca &amp; Pesawat</strong> &mdash; menggunakan band
                                X/C untuk deteksi presipitasi.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Infrared &mdash; Karakteristik</h3>
                <div>
                    <div>
                        <div>Sifat Fisik</div>
                        <div>
                            <ul>
                                <li><strong>Frekuensi:</strong> 300 GHz &ndash; 400 THz. Tepat di bawah cahaya tampak
                                    pada spektrum elektromagnetik.</li>
                                <li><strong>Arah Rambat:</strong> Sangat terfokus &mdash; berperilaku seperti cahaya
                                    biasa.</li>
                                <li><strong>Jangkauan:</strong> Sangat pendek, efektif hanya beberapa sentimeter hingga
                                    ~1 meter.</li>
                                <li><strong>Tidak bisa menembus dinding</strong> &mdash; diblokir oleh material padat
                                    apa pun.</li>
                                <li><strong>Butuh LoS ketat</strong> &mdash; pengirim dan penerima harus bertatapan
                                    langsung.</li>
                                <li><strong>Interferensi matahari:</strong> Cahaya matahari mengandung infrared yang
                                    dapat mengganggu sinyal.</li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/infrared_devices.png" alt="Perangkat infrared: remote TV, IrDA, sensor gerak">
                        <p>Perangkat berbasis infrared</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Infrared &mdash; Contoh Perangkat</h3>
                <div>
                    <div>
                        <p>Kendali Jarak Dekat</p>
                        <ul>
                            <li>&#x1F4FA; <strong>Remote Control TV / AC / Proyektor</strong> &mdash; pengguna paling
                                umum. Menggunakan LED infrared yang memancarkan kode pulsa.</li>
                            <li>&#x1F526; <strong>Remote Kamera DSLR</strong> &mdash; trigger shutter tanpa menyentuh
                                kamera untuk foto long-exposure.</li>
                            <li>&#x1F3AE; <strong>Nintendo Wii Sensor Bar</strong> &mdash; dua titik infrared yang
                                dilacak oleh Wiimote.</li>
                        </ul>
                    </div>
                    <div>
                        <p>Transfer Data &amp; Deteksi</p>
                        <ul>
                            <li>&#x1F4BB; <strong>IrDA (Infrared Data Association)</strong> &mdash; port transfer data
                                di laptop/HP era 1990&ndash;2000-an. Kecepatan hingga 16 Mbps (Fast-IR).</li>
                            <li>&#x1F512; <strong>Sensor Gerak PIR</strong> (Passive IR) &mdash; mendeteksi panas tubuh
                                manusia. Digunakan di alarm keamanan dan lampu otomatis.</li>
                            <li>&#x1F6D2; <strong>Barcode Scanner</strong> &mdash; beberapa model menggunakan LED IR.
                            </li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Komunikasi Satelit &mdash; Orbit &amp; Latensi
                </h3>
                <div>
                    <div>
                        <div>Tiga Jenis Orbit</div>
                        <div>
                            <table>
                                <tr>
                                    <th>Orbit</th>
                                    <th>Ketinggian</th>
                                    <th>Latensi</th>
                                    <th>Contoh</th>
                                </tr>
                                <tr>
                                    <td><strong>GEO</strong><br><span>Geostationary</span></td>
                                    <td>~35.786 km</td>
                                    <td>~500&ndash;700 ms</td>
                                    <td>Viasat, HughesNet, TV Parabola</td>
                                </tr>
                                <tr>
                                    <td><strong>MEO</strong><br><span>Medium Earth</span></td>
                                    <td>2.000&ndash;20.000 km</td>
                                    <td>~100&ndash;250 ms</td>
                                    <td>GPS, Galileo, Glonass</td>
                                </tr>
                                <tr>
                                    <td><strong>LEO</strong><br><span>Low Earth</span></td>
                                    <td>200&ndash;2.000 km</td>
                                    <td>~20&ndash;40 ms</td>
                                    <td>Starlink, OneWeb, Iridium</td>
                                </tr>
                            </table>
                        </div>
                        <div>
                            &#x1F4A1; GEO <em>stasioner</em> terhadap bumi &mdash; cocok untuk TV broadcast. LEO
                            bergerak cepat &mdash; butuh banyak satelit (konstelasi) tapi latensi sangat rendah.
                        </div>
                    </div>
                    <div>
                        <img src="https://informatika-itera.github.io/jarkom/img/week3/satellite_devices.png" alt="Sistem komunikasi satelit: uplink, orbit, downlink">
                        <p>Sistem komunikasi satelit (uplink&ndash;downlink)</p>
                    </div>
                </div>
            </section>

            
            <section>
                <h3><i></i> Komunikasi Satelit &mdash; Layanan &amp;
                    Perangkat</h3>
                <div>
                    <div>
                        <p>Internet &amp; Data</p>
                        <ul>
                            <li>&#x1F6F0;&#xFE0F; <strong>Starlink (SpaceX)</strong> &mdash; internet via LEO, tersedia
                                di Indonesia. Latensi ~20-40ms, kecepatan ~100-400 Mbps.</li>
                            <li>&#x2601;&#xFE0F; <strong>VSAT (Very Small Aperture Terminal)</strong> &mdash; internet
                                satelit GEO untuk kapal laut, rig minyak, desa terpencil. Antena kecil ~1.2m.</li>
                            <li>&#x1F4F1; <strong>Direct-to-Cell (Starlink / AST)</strong> &mdash; koneksi langsung ke
                                smartphone biasa tanpa SIM khusus.</li>
                        </ul>
                    </div>
                    <div>
                        <p>Navigasi &amp; Penyiaran</p>
                        <ul>
                            <li>&#x1F5FA;&#xFE0F; <strong>GPS</strong> &mdash; 31 satelit MEO milik AS. Akurasi sipil
                                ~3-5 meter. Digunakan di smartphone, kendaraan, survei.</li>
                            <li>&#x1F4E1; <strong>TV Satelit</strong> &mdash; Telkom-4 / MEASAT / Intelsat (GEO). Dish
                                parabola menangkap siaran langsung dari orbit.</li>
                            <li>&#x1F326;&#xFE0F; <strong>Satelit Cuaca</strong> &mdash; BMKG menggunakan data dari
                                satelit GEO untuk prakiraan cuaca nasional.</li>
                        </ul>
                    </div>
                </div>
            </section>

            
            <section>
                <h3>Perbandingan Keempat Unguided Media</h3>
                <div>
                    <table>
                        <tr>
                            <th>Jenis</th>
                            <th>Frekuensi</th>
                            <th>Arah</th>
                            <th>Jangkauan</th>
                            <th>Contoh Aplikasi</th>
                        </tr>
                        <tr>
                            <td><span>Gelombang Radio</span></td>
                            <td>3 Hz &ndash; 1 GHz</td>
                            <td>Omnidirectional</td>
                            <td>Puluhan &ndash; ratusan km</td>
                            <td>AM/FM Radio, Bluetooth, TV Analog, HT</td>
                        </tr>
                        <tr>
                            <td><span>Gelombang Mikro</span></td>
                            <td>1 &ndash; 300 GHz</td>
                            <td>Unidirectional (LoS)*</td>
                            <td>Beberapa &ndash; puluhan km</td>
                            <td>Wi-Fi*, BTS 4G/5G, Radar, Backhaul</td>
                        </tr>
                        <tr>
                            <td><span>Infrared</span></td>
                            <td>300 GHz &ndash; 400 THz</td>
                            <td>Terfokus (LoS ketat)</td>
                            <td>&lt; 1 meter</td>
                            <td>Remote TV/AC, IrDA, Sensor PIR</td>
                        </tr>
                        <tr>
                            <td><span>Satelit</span></td>
                            <td>1 &ndash; 40 GHz (&micro;wave)</td>
                            <td>Global (downlink luas)</td>
                            <td>Seluruh bumi</td>
                            <td>GPS, Starlink, VSAT, TV Parabola</td>
                        </tr>
                    </table>
                </div>
                <p>
                    <em>*Catatan: Secara praktis, Wi-Fi beroperasi secara omnidirectional. Klasifikasi di atas berdasarkan referensi Forouzan yang mengkategorikan berdasarkan spektrum frekuensi semata.</em>
                </p>
                <div>
                    &#x1F4CC; Infrared dan Radio adalah dua ekstrem yang berlawanan: infrared paling terbatas secara
                    jangkauan, radio paling luas &mdash; tapi radio juga paling tidak aman dari penyadapan.
                </div>
            </section>

            
            <section>
                <h3>Rangkuman Pertemuan 3</h3>
                <div>
                    <div>
                        <div>Konsep Sinyal &amp; Gangguan</div>
                        <div>
                            <ul>
                                <li><strong>Analog vs Digital:</strong> Analog bersifat
                                    kontinu (gelombang mulus), digital bersifat diskret (nilai pulsa biner).</li>
                                <li><strong>Gangguan Transmisi:</strong>
                                    <ul>
                                        <li><em>Attenuation:</em> Sinyal melemah seiring jarak.</li>
                                        <li><em>Distortion:</em> Perubahan bentuk sinyal komposit.</li>
                                        <li><em>Noise:</em> Gangguan sinyal liar (Crosstalk, Thermal, EMI).</li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div>
                        <div>Media Transmisi</div>
                        <div>
                            <ul>
                                <li><strong>Guided (Kabel):</strong>
                                    <ul>
                                        <li><em>Coaxial:</em> Berlapis shield, tahan noise.</li>
                                        <li><em>Twisted Pair:</em> UTP &amp; STP. Dipilin untuk atasi crosstalk.</li>
                                        <li><em>Fiber Optik:</em> Inti kaca, bandwidth masif, kebal EMI.</li>
                                    </ul>
                                </li>
                                <li><strong>Unguided (Nirkabel):</strong> Radio (omnidirectional), Mikro
                                    (unidirectional/LoS), Infrared (jarak sangat dekat), dan Satelit (GEO, MEO, LEO).
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>

            
            <section>
                <div>
                    <h3>&#x1F4DD; Tugas Pertemuan 3</h3>
                    <p>Tugas ini dirancang khusus berbasis
                        observasi nyata</p>

                    <div>
                        <p><strong>Audit Media Transmisi &amp; Gangguan Jaringan di
                                Lingkungan Anda</strong><br>
                            Pilih satu lokasi disekitar anda (rumah, kos, atau laboratorium kampus). Lakukan langkah
                            berikut:</p>

                        <p><span>1</span>
                            <strong>Pemetaan Fisik (Wajib Sketsa Tangan):</strong><br>
                            Gambarkan denah ruangan secara manual. Tandai posisi sumber internet (Modem/Router/Access
                            Point), letak perangkat pengguna (PC/Laptop/TV), dan jalur kabel yang ada.
                        </p>

                        <p><span>2</span>
                            <strong>Identifikasi Guided Media &amp; Potensi EMI:</strong><br>
                            Temukan minimal 1 jalur kabel jaringan (UTP/Coaxial/Fiber). Amati jalur fisiknya. Apakah
                            kabel tersebut ditumpuk bersama kabel listrik PLN? Analisislah potensi terjadinya
                            <em>Crosstalk</em> atau <em>EMI</em> pada kabel tersebut berdasarkan teori (misal: apakah
                            kabelnya UTP tanpa shield, atau sudah STP?).
                        </p>

                        <p><span>3</span>
                            <strong>Analisis Unguided Media (Attenuation &amp; Interferensi):</strong><br>
                            Amati sinyal Wi-Fi (Gelombang Mikro) di lokasi. Jelaskan secara teknis fenomena
                            <em>Attenuation</em> (redaman) yang terjadi ketika Anda berpindah dari dekat router ke
                            ruangan yang terhalang 2-3 tembok tebal. Apakah ada potensi interferensi dari perangkat
                            <em>Bluetooth</em> atau benda elektronik lain di sekitarnya?
                        </p>

                        <p><span>4</span>
                            <strong>Rekomendasi Solusi:</strong><br>
                            Berdasarkan temuan nomor 2 dan 3, berikan 1 rekomendasi perbaikan fisik (misal: relokasi
                            alat, penggantian jenis kabel) untuk mengurangi efek <em>Noise</em> atau
                            <em>Attenuation</em> di lokasi tersebut!
                        </p>
                    </div>
                    <div>
                        <div><i></i> Tulis tangan laporan &amp; sketsa</div>
                        <div><i></i> Scan/Foto jelas, jadikan PDF</div>
                        <div><i></i> Dikumpulkan di E-Learning</div>
                    </div>
                </div>
            </section>


            
            <section>$qa$, 6) on conflict (id) do update set stage_id = excluded.stage_id, title = excluded.title, body = excluded.body, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-c1$qa$, $qa$jarkom-p3$qa$, $qa$checkpoint$qa$, $qa$Media transmisi yang memakai cahaya untuk mengirim data adalah...$qa$, $qa$["Kabel UTP", "Fiber optik", "Kabel koaksial", "Gelombang radio"]$qa$::jsonb, 1, $qa$Fiber optik mengirim pulsa cahaya lewat serat kaca.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-c2$qa$, $qa$jarkom-p3$qa$, $qa$checkpoint$qa$, $qa$Konektor standar untuk kabel UTP pada LAN adalah...$qa$, $qa$["BNC", "RJ11", "RJ45", "SC"]$qa$::jsonb, 2, $qa$UTP Ethernet memakai konektor RJ45 (8 pin).$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-c3$qa$, $qa$jarkom-p3$qa$, $qa$checkpoint$qa$, $qa$Susunan kabel straight-through dipakai untuk menghubungkan...$qa$, $qa$["Switch ke switch sejenis", "PC ke PC langsung", "PC ke switch", "Router ke router langsung"]$qa$::jsonb, 2, $qa$Straight untuk perangkat berbeda jenis (PC-switch), crossover untuk sejenis.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-b1$qa$, $qa$jarkom-p3$qa$, $qa$battle$qa$, $qa$Sinyal melemah karena kabel terlalu panjang sehingga data tak terbaca di ujung. Gangguan ini disebut... dan solusinya...$qa$, $qa$["Distortion — ganti ke kabel fiber", "Attenuation — pasang repeater/amplifier", "Noise — turunkan frekuensi", "Crosstalk — pakai konektor BNC"]$qa$::jsonb, 1, $qa$Attenuation adalah hilangnya energi sinyal seiring jarak (dB); repeater memperkuat kembali sinyal.$qa$, 1) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-b2$qa$, $qa$jarkom-p3$qa$, $qa$battle$qa$, $qa$Untuk menghubungkan dua switch secara langsung, kabel UTP yang tepat adalah...$qa$, $qa$["Straight-through, karena perangkat berbeda jenis", "Crossover, karena kedua perangkat setingkat/sejenis", "Straight-through dengan standar 568-A di satu ujung", "Kabel coaxial dengan konektor BNC"]$qa$::jsonb, 1, $qa$Crossover (568-A di satu ujung, 568-B di ujung lain) menyilangkan pin Tx/Rx untuk perangkat sejenis.$qa$, 2) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-b3$qa$, $qa$jarkom-p3$qa$, $qa$battle$qa$, $qa$Backbone internet antar kota sebaiknya memakai...$qa$, $qa$["Multi-mode fiber karena intinya besar", "Single-mode fiber karena cahaya merambat lurus dan mencapai puluhan km", "UTP Cat 6 karena murah", "Coaxial karena tahan noise"]$qa$::jsonb, 1, $qa$Single-mode (inti sekitar 8 mikrometer) minim pantulan sehingga cocok untuk jarak sangat jauh.$qa$, 3) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-b4$qa$, $qa$jarkom-p3$qa$, $qa$battle$qa$, $qa$Sekitar 99 persen data antar benua lewat kabel fiber bawah laut, bukan satelit, karena...$qa$, $qa$["Satelit tidak bisa membawa data digital", "Fiber memberi bandwidth jauh lebih besar dengan latensi jauh lebih kecil", "Kabel laut lebih murah dipasang daripada satelit", "Satelit hanya untuk siaran TV"]$qa$::jsonb, 1, $qa$Satelit GEO punya delay propagasi sekitar 280 ms dan bandwidth terbatas; fiber antar benua hanya puluhan ms.$qa$, 4) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
insert into public.questions (id, stage_id, kind, question, options, correct_index, explanation, sort_order) values ($qa$jarkom-p3-b5$qa$, $qa$jarkom-p3$qa$, $qa$battle$qa$, $qa$Wi-Fi (2,4/5 GHz) secara akademis dikelompokkan sebagai gelombang mikro karena...$qa$, $qa$["Bersifat omnidirectional", "Frekuensinya berada pada rentang 1 GHz - 300 GHz", "Tidak butuh line-of-sight", "Jangkauannya mencapai puluhan kilometer"]$qa$::jsonb, 1, $qa$Klasifikasi Forouzan berbasis spektrum frekuensi; 2,4/5 GHz masuk pita microwave meski praktiknya memancar omnidirectional.$qa$, 5) on conflict (id) do update set stage_id = excluded.stage_id, kind = excluded.kind, question = excluded.question, options = excluded.options, correct_index = excluded.correct_index, explanation = excluded.explanation, sort_order = excluded.sort_order;
