# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/c-client/c-client-2002d-r1.ebuild,v 1.6 2004/04/16 20:25:06 randy Exp $

inherit flag-o-matic

MY_PN=imap
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="UW IMAP c-client library"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 sparc ppc hppa alpha"
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
	use pic || use alpha && append-flags -fPIC

	# Modifications so we can build it optimially and correctly
	cd ${S}/src/osdep/unix/
	cp Makefile Makefile.orig
	sed \
		-e "s:-g -fno-omit-frame-pointer -O6:${CFLAGS}:g" \
		-e 's:SSLDIR=/usr/local/ssl:SSLDIR=/usr:g' \
		-e 's:SSLCERTS=$(SSLDIR)/certs:SSLCERTS=/etc/ssl/certs:g' \
		< Makefile.orig > Makefile

	# Apply a patch to only build the stuff we need for c-client
	cd ${S}
	patch < ${FILESDIR}/${PV}-Makefile.patch

	# Remove the pesky checks about SSL stuff
	cd ${S}
	cp Makefile Makefile.orig
	grep -v 'read.*exit 1' <Makefile.orig >Makefile
}

src_compile() {
	if use ssl; then
		make lnp SSLTYPE=unix || die
	else
		make lnp SSLTYPE=none || die
	fi
}

src_install() {
	into /usr

	# Library binary
	dolib.a c-client/c-client.a
	dosym /usr/lib/c-client.a /usr/lib/libc-client.a

	# Headers
	insinto /usr/include/imap
	doins c-client/{c-client,mail,imap4r1,rfc822,linkage,misc,smtp,nntp}.h
	doins c-client/{osdep,env_unix,env,fs,ftl,nl,tcp}.h

	# Docs
	dodoc CPYRIGHT README docs/*.txt docs/CONFIG docs/RELNOTES

	docinto rfc
	dodoc docs/rfc/*.txt
}
