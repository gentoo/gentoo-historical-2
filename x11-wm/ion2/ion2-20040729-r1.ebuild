# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ion2/ion2-20040729-r1.ebuild,v 1.3 2006/02/07 09:11:22 twp Exp $

inherit eutils

DESCRIPTION="A tiling tabbed window manager designed with keyboard users in mind"
HOMEPAGE="http://www.iki.fi/tuomov/ion/"
SRC_URI="http://modeemi.fi/~tuomov/ion/dl/ion-2-${PV}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="xinerama"
DEPEND="
	|| (
		(
			x11-libs/libICE
			x11-libs/libSM
			x11-libs/libX11
			x11-libs/libXext
			xinerama? ( x11-libs/libXinerama )
		)
		virtual/x11
	)
	>=dev-lang/lua-5.0.2
	>=sys-devel/libtool-1.4.3"
RDEPEND="${DEPEND}
	|| (
		(
			x11-apps/xmessage
			x11-proto/xproto
			x11-proto/xextproto
			xinerama? ( x11-proto/xineramaproto )
		)
		virtual/x11
	)
	app-misc/run-mailcap"

S=${WORKDIR}/ion-2-${PV}

src_unpack() {

	unpack ${A}

	cd ${S}

	epatch ${FILESDIR}/ion2-20040601-rename.patch

}

src_compile() {

	local myconf=""

	if ! has_version '<x11-base/xfree-4.3.0'; then
		myconf="${myconf} --disable-xfree86-textprop-bug-workaround"
	fi

	autoreconf

	use hppa && myconf="${myconf} --disable-shared"

	econf \
		--sysconfdir=/etc/X11 \
		`use_enable xinerama` \
		${myconf} || die

	emake \
		DOCDIR=/usr/share/doc/${PF} || die

}

src_install() {

	make \
		MODULEDIR=${D}/usr/$(get_libdir)/ion2 \
		LCDIR=${D}/usr/$(get_libdir)/ion2/lc \
		prefix=${D}/usr \
		ETCDIR=${D}/etc/X11/ion2 \
		SHAREDIR=${D}/usr/share/ion2 \
		MANDIR=${D}/usr/share/man \
		DOCDIR=${D}/usr/share/doc/${PF} \
		install || die

	mv ${D}/usr/bin/ion ${D}/usr/bin/ion2
	mv ${D}/usr/bin/pwm ${D}/usr/bin/pwm2
	mv ${D}/usr/share/man/man1/ion.1 ${D}/usr/share/man/man1/ion2.1
	mv ${D}/usr/share/man/man1/pwm.1 ${D}/usr/share/man/man1/pwm2.1

	prepalldocs

	insinto /usr/include/ion2
	doins *.h *.mk mkexports.lua
	for i in de floatws ioncore ionws luaextl menu query; do
		insinto /usr/include/ion2/${i}
		doins ${i}/*.h
	done
	insinto /usr/include/ion2/libtu
	doins libtu/*.h

	echo -e "#!/bin/sh\n/usr/bin/ion2" > ${T}/ion2
	echo -e "#!/bin/sh\n/usr/bin/pwm2" > ${T}/pwm2
	exeinto /etc/X11/Sessions
	doexe ${T}/ion2 ${T}/pwm2

	insinto /usr/share/xsessions
	doins ${FILESDIR}/ion2.desktop ${FILESDIR}/pwm2.desktop

}
