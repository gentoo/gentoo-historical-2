# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/iputils/iputils-021109-r1.ebuild,v 1.4 2004/03/02 16:44:27 iggy Exp $

DESCRIPTION="Network monitoring tools including ping and ping6"
HOMEPAGE="ftp://ftp.inr.ac.ru/ip-routing"
SRC_URI="ftp://ftp.inr.ac.ru/ip-routing/${PN}-ss${PV}-try.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~sparc ~alpha ~ppc ~hppa ~mips ~amd64 ~ia64 ppc64 s390"
IUSE="static ipv6" #doc

DEPEND="virtual/glibc
	virtual/os-headers
	dev-util/yacc"
#	doc? ( app-text/openjade
#		dev-perl/SGMLSpm
#		app-text/docbook-sgml-dtd
#		app-text/docbook-sgml-utils )
RDEPEND="virtual/glibc"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	cp ${FILESDIR}/${P}-pfkey.patch include-glibc/net/pfkeyv2.h || die
	sed -e "27s:-O2:${CFLAGS}:;68s:./configure:unset CFLAGS\;./configure:" -i Makefile
	sed -e "20d;21d;22d;23d;24d" -i Makefile

	# not everybody wants ipv6 suids laying around on the filesystems
	use ipv6 || sed -i -e s:"IPV6_TARGETS=":"#IPV6_TARGETS=":g Makefile
}

src_compile() {

	use static && LDFLAGS="${LDFLAGS} -static"

	if [ -e ${ROOT}/usr/include/linux/pfkeyv2.h ]; then
		sed -e '1s:/usr/src/linux/include:/usr/include:' -i libipsec/Makefile
		sed -e '1s:/usr/src/linux/include:/usr/include:' -i setkey/Makefile
		sed -e '1s:/usr/src/linux/include:/usr/include:;10s:-ll:-lfl:' -i setkey/Makefile
		sed -e "51s:ifdef:ifndef:;68d; 69d; 70d;" -i racoon/grabmyaddr.c
		sed -e '461i\LIBS="$LIBS -lfl -lresolv"' -i racoon/configure.in
		cd ${S}/libipsec && emake || die
		cd ${S}/setkey && emake || die

		cd ${S}/racoon
		autoconf; econf || die; emake || die
	fi

	cd ${S}
	emake KERNEL_INCLUDE="/usr/include" || die

#	if [ "`use doc`" ]; then
#		make html || die
#	fi
	make man || die

}

src_install() {

	if [ -e ${ROOT}/usr/include/linux/pfkeyv2.h ]; then
		mkdir -p ${D}/usr/sbin; mkdir -p ${D}/usr/share/man/man8
		mkdir -p ${D}/usr/share/man/man5;
		cd ${S}/racoon && einstall || die

		into /usr
		dobin ${S}/setkey/setkey
	fi

	cd ${S}
	into /
	dobin ping
	use ipv6 && dobin ping6
	dosbin arping
	into /usr
	dobin tracepath
	use ipv6 && dobin trace{path,route}6
	dosbin clockdiff rarpd rdisc ipg tftpd

	fperms 4711 /bin/ping /usr/bin/tracepath

	use ipv6 && fperms 4711 /bin/ping6 \
		/usr/bin/trace{path,route}6

	dodoc INSTALL RELNOTES

	use ipv6 || rm doc/*6.8
	doman doc/*.8

#	if [ "`use doc`" ]; then
#		dohtml doc/*.html
#	fi

}
