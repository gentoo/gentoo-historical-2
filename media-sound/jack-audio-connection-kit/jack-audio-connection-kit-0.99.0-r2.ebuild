# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-audio-connection-kit/jack-audio-connection-kit-0.99.0-r2.ebuild,v 1.6 2007/02/28 22:16:44 genstef Exp $

inherit flag-o-matic eutils

DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://jackit.sourceforge.net/"
SRC_URI="mirror://sourceforge/jackit/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~mips ~ppc ppc64 ~sparc ~x86"
IUSE="altivec alsa caps doc debug jack-tmpfs oss portaudio"

RDEPEND="dev-libs/glib
	dev-util/pkgconfig
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	portaudio? ( media-libs/portaudio )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	!media-sound/jack-cvs"
DEPEND="${RDEPEND}
	!ppc-macos? ( sys-devel/autoconf )
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd ${S}

	if use !ppc-macos ; then
		# Add doc option and fix --march=pentium2 in caps test
		epatch ${FILESDIR}/${PN}-0.98.1-configure.patch && \
		WANT_AUTOCONF=2.5 autoconf
	fi

	# compile and install jackstart, see #92895
	epatch ${FILESDIR}/${P}-jackstart.patch
}

src_compile() {
	local myconf

	sed -i "s/^CFLAGS=\$JACK_CFLAGS/CFLAGS=\"\$JACK_CFLAGS $(get-flag -march)\"/" configure

	if use doc; then
		myconf="--enable-html-docs --with-html-dir=/usr/share/doc/${PF}"
	else
		myconf="--disable-html-docs"
	fi

	if use jack-tmpfs; then
		myconf="${myconf} --with-default-tmpdir=/dev/shm"
	else
		myconf="${myconf} --with-default-tmpdir=/var/run/jack"
	fi

	econf \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable caps capabilities) $(use_enable caps stripped-jackd) \
		$(use_enable debug) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		${myconf} || die "configure failed"
	emake || die "compilation failed"
}

src_install() {
	make DESTDIR=${D} datadir=${D}/usr/share install || die

	if ! use jack-tmpfs; then
		keepdir /var/run/jack
		chmod 4777 ${D}/var/run/jack
	fi

	if use doc; then
		mv ${D}/usr/share/doc/${PF}/reference/html \
		   ${D}/usr/share/doc/${PF}/

		mv ${S}/example-clients \
		   ${D}/usr/share/doc/${PF}/
	fi

	rm -rf ${D}/usr/share/doc/${PF}/reference
}
