# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/bind-tools/bind-tools-9.4.2_p2.ebuild,v 1.2 2008/08/02 12:22:05 chainsaw Exp $

inherit flag-o-matic

MY_PN=${PN//-tools}
MY_PV=${PV/_p2/-P2}
MY_P="${MY_PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="http://www.isc.org/products/BIND/bind9.html"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${MY_PV}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="idn ipv6"

DEPEND="idn? ( || ( sys-libs/glibc dev-libs/libiconv )
			net-dns/idnkit )"

src_unpack() {
	unpack ${A} || die
	cd "${S}" || die

	use idn && {
		# BIND 9.4.0 doesn't have this patch
		# epatch ${S}/contrib/idn/idnkit-1.0-src/patch/bind9/bind-${PV}-patch

		cd "${S}"/contrib/idn/idnkit-1.0-src
		epatch "${FILESDIR}"/${PN}-configure.patch
		cd -
	}

	# bug #151839
	sed -e \
		's:struct isc_socket {:#undef SO_BSDCOMPAT\n\nstruct isc_socket {:' \
		-i lib/isc/unix/socket.c
}

src_compile() {
	local myconf=
	use ipv6 && myconf="${myconf} --enable-ipv6" || myconf="${myconf} --enable-ipv6=no"
	use idn  && myconf="${myconf} --with-idn"

	has_version sys-libs/glibc || myconf="${myconf} --with-iconv"

	econf ${myconf} || die "Configure failed"

	cd "${S}"/lib
	emake -j1 || die "make failed in /lib"

	cd "${S}"/bin/dig
	emake -j1 || die "make failed in /bin/dig"

	cd "${S}"/lib/lwres/
	emake -j1 || die "make failed in /lib/lwres"

	cd "${S}"/bin/nsupdate/
	emake -j1 || die "make failed in /bin/nsupdate"

	cd "${S}"/bin/dnssec/
	emake -j1 || die "make failed in /bin/dnssec"
}

src_install() {
	dodoc README CHANGES FAQ

	cd "${S}"/bin/dig
	dobin dig host nslookup || die
	doman dig.1 host.1 nslookup.1 || die

	cd "${S}"/bin/nsupdate
	dobin nsupdate || die
	doman nsupdate.8 || die
	dohtml nsupdate.html || die

	cd "${S}"/bin/dnssec
	dobin dnssec-keygen || die
	doman dnssec-keygen.8 || die
	dohtml dnssec-keygen.html || die
}
