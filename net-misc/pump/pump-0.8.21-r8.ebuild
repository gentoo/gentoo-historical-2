# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/pump/pump-0.8.21-r8.ebuild,v 1.3 2005/11/18 14:06:22 uberlord Exp $

inherit eutils

PATCHLEVEL="2"

DESCRIPTION="This is the DHCP/BOOTP client written by RedHat"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/p/pump/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}-${PATCHLEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=">=dev-libs/popt-1.5"

PROVIDE="virtual/dhcpc"

src_unpack() {
	cd "${WORKDIR}"
	unpack "${PN}_${PV}.orig.tar.gz"
	cd "${S}"

	# Apply Debians pump patchset - they fix things good :)
	epatch "${DISTDIR}/${PN}_${PV}-${PATCHLEVEL}.diff.gz"

	# Enable the -e (--etc-dir) option to specify where to make
	# resolv.conf - default /etc
	# Enable the -m (--route-metric) option to specify the default
	# metric applied to routes
	# Enable the --keep-up option to keep interfaces up when we release
	# Enable the creation of /etc/ntp.conf and the --no-ntp option
	epatch "${FILESDIR}/pump-${PV}-gentoo.diff"

	# Clean compile on GCC4
	epatch "${FILESDIR}/pump-${PV}-gcc4.patch"

	# Only install specific po files if LINGUAS is set
	if [[ -n ${LINGUAS} ]]; then
		cd po
		local p
		for l in $(ls *.po) ; do
			[[ " ${LINGUAS} " != *" ${l%%.po} "* ]] && rm -f "${l}"
		done
	fi
}

src_compile() {
	make DEB_CFLAGS="-fPIC ${CFLAGS}" pump || die
}

src_install() {
	into /
	dosbin pump || die

	doman pump.8
	dodoc CREDITS

	into /usr/
	dolib.a libpump.a
	insinto /usr/include/
	doins pump.h

	make -C po install datadir="${D}/usr/share/"
}
