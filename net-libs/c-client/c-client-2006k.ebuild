# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/c-client/c-client-2006k.ebuild,v 1.2 2008/03/02 20:07:55 robbat2 Exp $

inherit flag-o-matic eutils libtool

MY_PN=imap
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}

MAKEFILE_PATCH_VER="2006k"
SO_PATCH_VER="2006k"
KOLAB_PATCH_VER="2006k"

DESCRIPTION="UW IMAP c-client library"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/old/${MY_P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="kernel_linux kernel_FreeBSD kolab pam ssl"

RDEPEND="ssl? ( dev-libs/openssl )
	!virtual/imap-c-client"
DEPEND="${RDEPEND}
	kernel_linux? ( pam? ( >=sys-libs/pam-0.72 ) )"
PROVIDE="virtual/imap-c-client"

src_unpack() {
	unpack ${A}

	# Tarball packed with bad file perms
	chmod -R u+rwX,go-w "${S}"

	# lots of things need -fPIC, including various platforms, and this library
	# generally should be built with it anyway.
	append-flags -fPIC

	cd "${S}"

	# Modifications so we can build it optimally and correctly
	sed \
		-e "s:BASECFLAGS=\".*\":BASECFLAGS=:g" \
		-e 's:SSLDIR=/usr/local/ssl:SSLDIR=/usr:g' \
		-e 's:SSLCERTS=$(SSLDIR)/certs:SSLCERTS=/etc/ssl/certs:g' \
		-i src/osdep/unix/Makefile || die "Makefile sed fixing failed"

	# Targets should use the Gentoo (ie linux) fs
	sed -e '/^bsf:/,/^$/ s:ACTIVEFILE=.*:ACTIVEFILE=/var/lib/news/active:g' \
		-i src/osdep/unix/Makefile || die "Makefile sex fixing failed for FreeBSD"

	# Apply a patch to only build the stuff we need for c-client
	epatch "${FILESDIR}"/${PN}-${MAKEFILE_PATCH_VER}_GENTOO_Makefile.patch || die "epatch failed"

	# Apply patch to add the compilation of a .so for PHP
	# This was previously conditional, but is more widely useful.
	epatch "${FILESDIR}"/${PN}-${SO_PATCH_VER}_GENTOO_amd64-so-fix.patch

	# Add kolab support.
	# http://kolab.org/cgi-bin/viewcvs-kolab.cgi/server/patches/imap/
	if use kolab ; then
		epatch "${FILESDIR}"/${PN}-${KOLAB_PATCH_VER}_KOLAB_Annotations.patch || die "epatch failed"
	fi

	# Remove the pesky checks about SSL stuff
	sed -e '/read.*exit/d' -i Makefile
	elibtoolize
}

src_compile() {
	local ssltype target
	use ssl && ssltype="unix" || ssltype="none"
	if use kernel_linux ; then
		use pam && target=lnp || target=lnx
	elif use kernel_FreeBSD ; then
		target=bsf
	fi
	# no parallel builds supported!
	emake -j1 $target SSLTYPE=${ssltype} EXTRACFLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	into /usr

	# Library binary
	dolib.a c-client/c-client.a || die
	dosym c-client.a /usr/$(get_libdir)/libc-client.a

	# Now the shared library
	dolib.so c-client/libc-client.so.1.0.0 || die
	# these are created by ldconfig!
	#cd ${D}/usr/$(get_libdir)
	#ln -s libc-client.so.1.0.0 libc-client.so.1
	#ln -s libc-client.so.1.0.0 libc-client.so

	# Headers
	insinto /usr/include/imap
	doins c-client/*.h
	doins c-client/linkage.c
	#exclude these dupes (can't do it before now due to symlink hell)
	rm "${D}"/usr/include/imap/os_*.h

	# Docs
	dodoc README docs/*.txt docs/CONFIG docs/RELNOTES

	docinto rfc
	dodoc docs/rfc/*.txt
}
