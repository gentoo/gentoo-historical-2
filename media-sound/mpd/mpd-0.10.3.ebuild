# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpd/mpd-0.10.3.ebuild,v 1.4 2004/04/20 07:50:56 eradicator Exp $

IUSE="oggvorbis mad aac audiofile ipv6"

DESCRIPTION="Music Player Daemon (mpd)"
SRC_URI="mirror://sourceforge/musicpd/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://www.musicpd.org"

KEYWORDS="~x86 ~amd64 ~sparc"
SLOT="0"
LICENSE="GPL-2"

DEPEND="oggvorbis? ( media-libs/libvorbis )
	mad? ( media-sound/mad )
	aac? ( >=media-libs/faad2-2.0_rc2 )
	audiofile? ( media-libs/audiofile )
	flac? ( >=media-libs/flac-1.1.0 )
	media-libs/libid3tag
	>=media-libs/libao-0.8.4
	sys-libs/zlib"

src_compile() {
	local myconf
	myconf="`use_enable aac` `use_enable audiofile` `use_enable ipv6` `use_enable flac`"

	use oggvorbis \
		|| myconf="${myconf} --disable-ogg  --disable-oggtest \
			--disable-vorbistest"
	use mad || myconf="${myconf} --enable-mpd-mad --enable-mpd-id3tag"

	econf ${myconf} || die "could not configure"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR=${D} || die
	rm -rf ${D}/usr/share/doc/mpd/
	dodoc COPYING ChangeLog INSTALL README TODO UPGRADING
	dodoc doc/COMMANDS doc/mpdconf.example

	insinto /etc
	newins doc/mpdconf.example mpd.conf

	exeinto /etc/init.d
	newexe ${FILESDIR}/mpd.rc6 mpd

	dosed 's:^port.*$:port "2100":' /etc/mpd.conf
	dosed 's:^music_directory.*$:music_directory "/usr/share/mpd/music":' /etc/mpd.conf
	dosed 's:^playlist_directory.*$:playlist_directory "/usr/share/mpd/playlists":' /etc/mpd.conf
	dosed 's:^log_file.*$:log_file "/var/log/mpd.log":' /etc/mpd.conf
	dosed 's:^error_file.*$:error_file "/var/log/mpd.error.log":' /etc/mpd.conf
}

pkg_postinst() {
	einfo "libao prior to 0.8.4 has issues with the ALSA drivers, please refer to the FAQ"
	einfo "http://musicpd.sourceforge.net/faq.php if you are having problems."
}
