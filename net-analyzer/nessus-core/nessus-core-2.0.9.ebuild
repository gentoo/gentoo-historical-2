# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nessus-core/nessus-core-2.0.9.ebuild,v 1.2 2003/11/24 07:55:39 phosphan Exp $

DESCRIPTION="A remote security scanner for Linux (nessus-core)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz
	prelude? ( http://www.exaprobe.com/labs/downloads/Nessus_Patch/patch_0.nessus-core.2.0.7 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="tcpd gtk2 debug prelude"

DEPEND="=net-analyzer/libnasl-${PV}
	tcpd? ( sys-apps/tcp-wrappers )
	X? ( x11-base/xfree )
	!gtk2? ( =x11-libs/gtk+-1.2* )
	gtk2? ( =x11-libs/gtk+-2* )
	prelude? ( dev-libs/libprelude )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	use prelude && (
		epatch ${DISTDIR}/patch_0.nessus-core.2.0.7
		epatch ${FILESDIR}/patch_1.nessus-core.2.0.7
	)
}

src_compile() {
	local myconf
	# no use_enable because of bug 31670
	if [ `use tcpd` ]; then
		myconf="${myconf} --enable-tcpwrappers"
	fi
	if [ `use debug` ]; then
		myconf="${myconf} --enable-debug"
	else
		myconf="${myconf} --disable-debug"
	fi
	if [ `use prelude` ]; then
		export LIBPRELUDE_CONFIG=/usr/bin/libprelude-config
	fi
	econf ${myconf} || die "configure failed"
	emake || die "emake failed"

}

src_install() {
	make \
		prefix=${D}/usr \
		sysconfdir=${D}/etc \
		localstatedir=${D}/var/lib \
		mandir=${D}/usr/share/man \
		install || die "Install failed nessus-core"
	cd ${S}
	dodoc README* UPGRADE_README CHANGES
	dodoc doc/*.txt doc/ntp/*
	insinto /etc/init.d
	insopts -m 755
	newins ${FILESDIR}/nessusd-r6 nessusd
	keepdir /var/lib/nessus/logs
	keepdir /var/lib/nessus/users
}
