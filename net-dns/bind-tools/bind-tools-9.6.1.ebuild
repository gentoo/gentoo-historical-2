# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/bind-tools/bind-tools-9.6.1.ebuild,v 1.1 2009/07/19 18:40:15 idl0r Exp $

inherit eutils

MY_PN=${PN//-tools}
MY_PV=${PV/_p1/-P1}
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="bind tools: dig, nslookup, host, nsupdate, dnssec-keygen"
HOMEPAGE="https://www.isc.org/software/bind"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${MY_PV}/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc idn ipv6 ssl xml"

DEPEND="ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )
	idn? (
		|| ( sys-libs/glibc dev-libs/libiconv )
		net-dns/idnkit
		)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	use idn && {
		cd "${S}"/contrib/idn/idnkit-1.0-src
		epatch "${FILESDIR}"/${PN}-configure.patch
		cd -
	}

	epatch "${FILESDIR}"/${PN}-9.5.0_p1-lwconfig.patch

	# bug #151839
	sed -i -e \
		's:struct isc_socket {:#undef SO_BSDCOMPAT\n\nstruct isc_socket {:' \
		lib/isc/unix/socket.c || die
}

src_compile() {
	local myconf=

	has_version sys-libs/glibc || myconf="${myconf} --with-iconv"

	econf \
		$(use_enable ipv6) \
		$(use_with idn) \
		$(use_with ssl openssl) \
		$(use_with xml libxml2) \
		${myconf}

	emake -C lib/ || die "emake lib failed"
	emake -C bin/dig/ || die "emake bin/dig failed"
	emake -C bin/nsupdate/ || die "emake bin/nsupdate failed"
	emake -C bin/dnssec/ || die "emake bin/dnssec failed"
}

src_install() {
	dodoc README CHANGES FAQ || die

	cd "${S}"/bin/dig
	dobin dig host nslookup || die
	doman {dig,host,nslookup}.1 || die

	cd "${S}"/bin/nsupdate
	dobin nsupdate || die
	doman nsupdate.1 || die
	if use doc; then
		dohtml nsupdate.html || die
	fi

	cd "${S}"/bin/dnssec
	dobin dnssec-keygen || die
	doman dnssec-keygen.8 || die
	if use doc; then
		dohtml dnssec-keygen.html || die
	fi
}
