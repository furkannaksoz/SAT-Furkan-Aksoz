DONUK YOLCULUK – README

1. Proje Tanıtımı

Donuk Yolculuk, Godot oyun motoru kullanılarak geliştirilen 2D platform türünde bir oyundur. Oyun, buz temalı bir dünyada geçer. Oyuncu; engelleri aşarak, düşmanlardan kaçınarak ve görevleri tamamlayarak ilerler. Projenin temel odağı; oyun sistemlerinin (karakter kontrolü, etkileşim, düşman yapay zekâsı, seviye geçişleri ve ses sistemi) analiz edilmesi, tasarlanması ve uygulanmasıdır.

Bu proje Sistem Analizi ve Tasarımı dersi kapsamında hazırlanmıştır. Bu nedenle sadece oyun oynamaya yönelik değil; aynı zamanda gereksinim analizi, sistem bileşenlerinin belirlenmesi ve işleyişin planlanması yaklaşımıyla geliştirilmiştir.

⸻

2. Kullanılan Teknoloji
	•	Oyun Motoru: Godot Engine 3.6
	•	Programlama Dili: GDScript
	•	Kullanılan Teknolojiler: Yalnızca Godot (ek bir framework veya harici sistem kullanılmamıştır)

⸻

3. Oyunun Amacı ve Oynanış

Oyunun temel amacı, oyuncunun buzlarla kaplı seviyelerde ilerleyerek hedef noktaya ulaşmasıdır. Bu süreçte oyuncu:
	•	Platformlar arasında geçiş yapar (zıplama, hareket)
	•	Düşmanların bulunduğu bölgelerde dikkatli ilerler
	•	Görev/şart mekaniklerini tamamlar (örnek: kurtarma şartı, anahtar-kapı ilişkisi)
	•	Seviye sonuna ulaştığında bir sonraki bölüme geçer

Oyun akışı, oyuncunun yaptığı eylemlere göre ilerler. Bazı kapılar veya geçiş noktaları belirli koşullar sağlanmadan aktif olmaz. Bu yaklaşım, oyun içi “durum yönetimi” mantığıyla kontrol edilir.

⸻

4. Temel Özellikler

4.1 Karakter Kontrol Sistemi

Oyuncu karakteri 2D platform mantığına uygun şekilde tasarlanmıştır. Hareket ve zıplama gibi temel kontroller uygulanmıştır. Kontrollerin tepkiselliği, seviyelerde rahat oynanış sağlayacak şekilde ayarlanmıştır.

4.2 Seviye Sistemi ve Geçişler

Oyun birden fazla seviyeden oluşur. Her seviye kendi içinde:
	•	Harita düzeni (platformlar, engeller)
	•	Düşman yerleşimi
	•	Etkileşim nesneleri
	•	Çıkış/kapı mantığı
barındırır. Seviye geçişleri, belirli koşullar sağlandığında aktif olacak şekilde planlanmıştır.

4.3 Anahtar – Kapı Mekaniği

Oyunda bazı kapıların açılabilmesi için anahtar toplanması gerekir. Anahtar alındığında sistem, oyuncunun “görevi tamamladı” durumunu günceller ve kapının açılmasına izin verir. Bu mekanik, kullanıcıya hedef ve ilerleme hissi kazandırır.

4.4 Kurtarma ve Takip Mekaniği

Oyunda kurtarılması gereken bir karakter bulunur. Oyuncu bu karakteri kurtardıktan sonra karakter belirli bir mesafede oyuncuyu takip eder. Bu takip sistemi; algılama alanı, oyuncu menzili ve takip durumu gibi durumlara göre çalışır. Bu sayede oyun “yalnızca bitişe koşma” değil, görev odaklı bir akış kazanır.

4.5 Düşman Yapay Zekâsı (AI)

Düşmanlar temel seviyede iki mod ile çalışır:
	•	Devriye modu: Belirlenmiş alanda hareket eder
	•	Takip modu: Oyuncu algılama alanına girince oyuncuyu takip eder

Oyuncu menzilden çıktığında düşman tekrar devriye moduna döner. Böylece seviye zorluğu dengeli ve anlaşılır şekilde yönetilir.

4.6 Ses Efektleri

Oyun içinde etkileşimlere bağlı sesler kullanılmıştır (örnek: kapıdan geçiş sesi). Sesler, olay gerçekleştiğinde tetiklenerek oyuncuya geri bildirim verir. Bu, hem atmosfer hem de kullanıcı deneyimi açısından oyunu güçlendirir.

4.7 Ana Menü

Oyun başlangıcında ana menü ekranı bulunur. Buradan oyuna başlama gibi temel işlemler yapılabilir. Ana menü, oyunun ilk izlenimi olduğu için sade ve anlaşılır şekilde tasarlanmıştır.

⸻

5. Klasör Yapısı 

Proje klasörü genel olarak aşağıdaki bölümlerden oluşur:
	•	assets klasörü: Oyun içindeki görseller, sesler ve arka plan dosyaları burada yer alır.
	•	sprites (karakter ve düşman görselleri/animasyonları)
	•	sounds (kapı, etkileşim ve diğer ses efektleri)
	•	backgrounds (seviye arka planları)
	•	scenes klasörü: Godot sahneleri bu klasörde tutulur.
	•	ana menü sahnesi
	•	Level 1 sahnesi
	•	Level 2 sahnesi
	•	kapı, anahtar gibi sahne bileşenleri
	•	scripts klasörü: Oyun mantığını oluşturan GDScript dosyaları burada bulunur.
	•	player (oyuncu hareket ve kontrol sistemi)
	•	enemy (düşman davranışları: devriye/takip)
	•	door/key (kapı ve anahtar etkileşimleri)
	•	seviye kontrol scriptleri (gerekli durum kontrolleri)
	•	project dosyaları: Godot’un proje ayarlarını ve ana çalışma dosyalarını içerir (project.godot vb.).

⸻

6. Kurulum ve Çalıştırma

6.1 Godot ile Çalıştırma
	1.	Godot Engine 3.6 sürümünü açın.
	2.	Proje klasörü içindeki project.godot dosyasını seçerek projeyi açın.
	3.	Godot içinde Play (Çalıştır) butonuna basarak oyunu çalıştırın.

6.2 EXE Çıktısı ile Çalıştırma (Varsa)

Eğer proje klasörü içinde export alınmış bir Windows çalıştırılabilir dosyası bulunuyorsa, ilgili .exe dosyasını açarak oyunu direkt çalıştırabilirsiniz.

⸻

7. Sistem Analizi ve Tasarımı Açısından Proje Yaklaşımı

Bu proje geliştirilirken şu temel adımlar izlenmiştir:
	•	Kullanıcı gereksinimlerinin belirlenmesi (oynanış, görevler, etkileşimler)
	•	Sistem bileşenlerinin ayrılması (oyuncu, düşman, kapı-anahtar, takip sistemi, seviye geçişleri)
	•	Durum yönetimi mantığının kurulması (anahtar alındı mı, kurtarma yapıldı mı, kapı açılabilir mi)
	•	Her bileşenin test edilmesi ve hata ayıklama sürecinin yürütülmesi
	•	Nihai olarak sahnelerin birbiriyle entegre edilmesi ve oyun akışının tamamlanması

Bu sayede proje, yalnızca “oyun çıktı” değil; aynı zamanda sistematik bir tasarım ve uygulama süreciyle tamamlanmıştır.

⸻

8. Geliştirici Bilgisi
	•	Geliştirici: Furkan aksöz
	•	Ders: Sistem Analizi ve Tasarımı
	•	Proje Türü: Godot 3.6 ile 2D Platform Oyun Projesi
