# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/dsniff/dsniff-2.4_beta1-r3.ebuild,v 1.11 2010/01/16 07:42:33 pva Exp $

inherit autotools eutils flag-o-matic toolchain-funcs

DESCRIPTION="A collection of tools for network auditing and penetration testing"
HOMEPAGE="http://monkey.org/~dugsong/dsniff/"
SRC_URI="http://monkey.org/~dugsong/dsniff/beta/${P/_beta/b}.tar.gz
	mirror://gentoo/${PN}-2.4_beta1-debian-r1.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~sparc x86"
IUSE="X"

DEPEND="net-libs/libpcap
	>=net-libs/libnet-1.1.2.1-r1
	=net-libs/libnids-1.18
	>=dev-libs/openssl-0.9.6e
	>=sys-libs/db-4.2.52_p4
	sys-apps/sed
	X? ( x11-libs/libXmu )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_beta1/}"

src_unpack() {
	unpack ${A}

	# Debian's patchset
	epatch "${DISTDIR}"/${PN}-2.4_beta1-debian-r1.patch.bz2

	# Making sure data files get correctly installed and that dsniff
	# can find them
	# Working around dsniff b0rky config script
	# Data stuff goes into /etc/dsniff
	cd "${S}"
	sed -i \
		-e 's:-ldb2:-ldb2 -lpthread:' \
		-e "s:lib':':" \
		configure || die "sed configure"
	sed -i 's:-DDSNIFF_LIBDIR=\\\"$(libdir)/\\\"::' Makefile.in || die "sed makefile"
	epatch "${FILESDIR}"/2.3-makefile.patch

	# Bug 125084
	epatch "${FILESDIR}"/${PN}-httppostfix.patch

	# Allow amd64 compilation
	epatch "${FILESDIR}"/${PN}-lresolv.patch

	eautoreconf
}

src_compile() {
	if has_version '>=sys-libs/glibc-2.4' ; then
		append-flags -DCLK_TCK=CLOCKS_PER_SEC
	fi
	econf \
		$(use_with X x) \
		|| die "econf failed"
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake install install_prefix="${D}" || die "emake install failed"
	dodir /etc/dsniff
	cp "${D}"/usr/share/dsniff/{dnsspoof.hosts,dsniff.{magic,services}} \
		"${D}"/etc/dsniff/
	dodoc CHANGES README TODO
}
