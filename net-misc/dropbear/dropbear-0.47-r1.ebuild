# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbear/dropbear-0.47-r1.ebuild,v 1.3 2006/02/02 17:02:24 gustavoz Exp $

inherit eutils

DESCRIPTION="small SSH 2 client/server designed for small memory environments"
HOMEPAGE="http://matt.ucc.asn.au/dropbear/dropbear.html"
SRC_URI="http://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2
	http://matt.ucc.asn.au/dropbear/testing/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~s390 ~sh sparc ~x86"
IUSE="minimal multicall pam static zlib"

RDEPEND="zlib? ( sys-libs/zlib )
	pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}
	>=sys-apps/portage-2.0.51"
PROVIDE="virtual/ssh"

set_options() {
	use minimal \
		&& progs="dropbear dbclient dropbearkey" \
		|| progs="dropbear dbclient dropbearkey dropbearconvert scp"
	use multicall && makeopts="${makeopts} MULTI=1"
	use static && makeopts="${makeopts} STATIC=1"
}

pkg_setup() {
	enewgroup sshd 22
	enewuser sshd 22 -1 /var/empty sshd
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/dropbear-0.45-urandom.patch
	epatch "${FILESDIR}"/dropbear-0.46-dbscp.patch
	epatch "${FILESDIR}"/dropbear-0.47-CVE-2006-0225.patch
}

src_compile() {
	local myconf
	# --disable-syslog? wouldn't need logger in init.d
	use minimal && myconf="--disable-lastlog"
	econf ${myconf} $(use_enable zlib) $(use_enable pam) || die
	set_options
	emake ${makeopts} PROGRAMS="${progs}" || die "make ${makeopts} failed"
}

src_install() {
	set_options
	make install DESTDIR="${D}" ${makeopts} PROGRAMS="${progs}" || die "make install failed"
	doman *.8
	newinitd "${FILESDIR}"/dropbear.init.d dropbear
	newconfd "${FILESDIR}"/dropbear.conf.d dropbear
	dodoc CHANGES README TODO SMALL MULTI

	# The multi install target does not install the links
	if use multicall ; then
		cd "${D}"/usr/bin
		local x
		for x in ${progs} ; do
			ln -s dropbearmulti ${x}
		done
		rm -f dropbear
		dodir /usr/sbin
		dosym ../bin/dropbearmulti /usr/sbin/dropbear
		cd "${S}"
	fi

	mv "${D}"/usr/bin/{,db}scp
}
