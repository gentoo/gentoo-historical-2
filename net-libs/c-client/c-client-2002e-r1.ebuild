# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/c-client/c-client-2002e-r1.ebuild,v 1.7 2004/06/24 23:10:47 agriffis Exp $

inherit flag-o-matic eutils

MY_PN=imap
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="UW IMAP c-client library"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc ppc hppa alpha ia64 amd64"
IUSE="ssl pic"

RDEPEND="ssl? ( dev-libs/openssl )
	 !virtual/imap-c-client"
DEPEND="${RDEPEND}
	>=sys-libs/pam-0.72"
PROVIDE="virtual/imap-c-client"

src_unpack() {
	unpack ${A}

	# Tarball packed with bad file perms
	chmod -R ug+w ${S}

	# alpha needs -fPIC
	use pic || use alpha || use amd64 && append-flags -fPIC

	# Modifications so we can build it optimially and correctly
	sed \
		-e "s:BASECFLAGS=\".*\":BASECFLAGS=\"${CFLAGS}\":g" \
		-e 's:SSLDIR=/usr/local/ssl:SSLDIR=/usr:g' \
		-e 's:SSLCERTS=$(SSLDIR)/certs:SSLCERTS=/etc/ssl/certs:g' \
		-i ${S}/src/osdep/unix/Makefile || die "Makefile sed fixing failed"

	# Apply a patch to only build the stuff we need for c-client
	EPATCH_OPTS="${EPATCH_OPTS} -d ${S}" \
	epatch ${FILESDIR}/2002d-Makefile.patch || die "epatch failed"

	# Remove the pesky checks about SSL stuff
	sed -e '/read.*exit/d' -i ${S}/Makefile
}

src_compile() {
	local ssltype
	use ssl && ssltype="unix" || ssltype="none"
	# no parallel builds supported!
	make lnp SSLTYPE=${ssltype} || die "make failed"
}

src_install() {
	into /usr

	# Library binary
	dolib.a c-client/c-client.a
	dosym /usr/lib/c-client.a /usr/lib/libc-client.a

	# Headers
	insinto /usr/include/imap
	doins c-client/*.h
	doins c-client/linkage.c
	#exclude these dupes (can't do it before now due to symlink hell)
	rm ${D}/usr/include/imap/os_*.h

	# Docs
	dodoc CPYRIGHT README docs/*.txt docs/CONFIG docs/RELNOTES

	docinto rfc
	dodoc docs/rfc/*.txt
}
