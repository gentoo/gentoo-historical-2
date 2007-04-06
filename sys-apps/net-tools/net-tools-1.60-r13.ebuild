# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/net-tools/net-tools-1.60-r13.ebuild,v 1.4 2007/04/06 10:36:10 dertobi123 Exp $

inherit flag-o-matic toolchain-funcs eutils

PVER="1.6"
DESCRIPTION="Standard Linux networking tools"
HOMEPAGE="http://sites.inka.de/lina/linux/NetTools/"
SRC_URI="http://www.tazenda.demon.co.uk/phil/net-tools/${P}.tar.bz2
	mirror://gentoo/${P}-patches-${PVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="nls static"

RDEPEND="!sys-apps/mii-diag
	!net-misc/etherwake
	!sys-apps/nictools"
DEPEND="nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/patch/*.patch
	cp "${WORKDIR}"/extra/config.{h,make} . || die
	mkdir include/linux
	cp "${WORKDIR}"/extra/*.h include/linux/
	mv "${WORKDIR}"/extra/ethercard-diag/ "${S}"/ || die

	if use static ; then
		append-flags -static
		append-ldflags -static
	fi

	sed -i \
		-e "/^COPTS =/s:=:=${CFLAGS}:" \
		-e "/^LOPTS =/s:=:=${LDFLAGS}:" \
		Makefile || die "sed FLAGS Makefile failed"

	if ! use nls ; then
		sed -i \
			-e '/define I18N/s:1$:0:' config.h \
			|| die "sed config.h failed"
		sed -i \
			-e '/^I18N=/s:1$:0:' config.make \
			|| die "sed config.make failed"
	fi
}

src_compile() {
	tc-export CC
	emake libdir || die "emake libdir failed"
	emake || die "emake failed"
	emake -C ethercard-diag || die "emake ethercard-diag failed"

	if use nls ; then
		emake i18ndir || die "emake i18ndir failed"
	fi
}

src_install() {
	make BASEDIR="${D}" install || die "make install failed"
	make -C ethercard-diag DESTDIR="${D}" install || die "make install ethercard-diag failed"
	mv "${D}"/usr/share/man/man8/ether{,-}wake.8
	mv "${D}"/usr/sbin/mii-diag "${D}"/sbin/ || die "mv mii-diag failed"
	mv "${D}"/bin/* "${D}"/sbin/ || die "mv bin to sbin failed"
	mv "${D}"/sbin/{hostname,domainname,netstat,dnsdomainname,ypdomainname,nisdomainname} "${D}"/bin/ \
		|| die "mv sbin to bin failed"
	dodir /usr/bin
	dosym /bin/hostname /usr/bin/hostname

	dodoc README README.ipv6 TODO
}
