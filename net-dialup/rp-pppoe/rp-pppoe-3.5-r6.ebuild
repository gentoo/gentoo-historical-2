# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/rp-pppoe/rp-pppoe-3.5-r6.ebuild,v 1.3 2005/02/13 05:49:06 vapier Exp $

inherit eutils

DESCRIPTION="A user-mode PPPoE client and server suite for Linux"
HOMEPAGE="http://www.roaringpenguin.com/"
SRC_URI="http://www.roaringpenguin.com/penguin/pppoe/${P}.tar.gz
	ftp://ftp.samba.org/pub/ppp/ppp-2.4.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ~mips ~ppc ~sparc x86"
IUSE="X tcltk"

DEPEND="net-dialup/ppp
	X? ( tcltk? (
		virtual/x11
		dev-lang/tcl
		dev-lang/tk ) )"

src_unpack() {
	unpack ${A} || die "failed to unpack"
	cd ${S} || die "${S} not found"

	# Patch to enable integration of adsl-start and adsl-stop with
	# baselayout-1.11.x so that the pidfile can be found reliably per interface
	#These 2 patches should be merged some day
	epatch ${FILESDIR}/rp-pppoe-3.5-gentoo-netscripts.patch

	epatch ${FILESDIR}/rp-pppoe-3.5-dsa-557.patch #66296

	#Avoid "setXid, dynamically linked and using lazy bindings" QA notice
	sed -i -e 's:\(@CC@\) \(-o pppoe-wrapper wrapper.o\):\1 -Wl,-z,now \2:' gui/Makefile.in

	# sanbdox violation workaround
	sed -i -e 's/modprobe/#modprobe/' src/configure || die "sed failed"
}

src_compile() {
	addpredict /dev/ppp

	cd ${S}/src
	econf --enable-plugin=../../ppp-2.4.3|| die "econf failed"
	emake || die "emake failed"

	if use X && use tcltk; then
		make -C ${S}/gui || die "gui make failed"
	fi
}

src_install () {
	cd ${S}/src
	make RPM_INSTALL_ROOT=${D} docdir=/usr/share/doc/${PF} install \
		|| die "install failed"
	prepalldocs

	if use X && use tcltk; then
		make -C ${S}/gui install RPM_INSTALL_ROOT=${D} \
		datadir=/usr/share/doc/${PF}/ || die "gui install failed"
		dosym /usr/share/doc/${PF}/tkpppoe /usr/share/tkpppoe
	fi

	exeinto /etc/init.d ; newexe ${FILESDIR}/rp-pppoe.rc rp-pppoe
}

pkg_postinst() {
	einfo "Use adsl-setup to configure your dialup connection"
}
