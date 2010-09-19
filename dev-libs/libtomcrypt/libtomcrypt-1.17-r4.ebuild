# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libtomcrypt/libtomcrypt-1.17-r4.ebuild,v 1.1 2010/09/19 04:35:35 jer Exp $

EAPI="2"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="modular and portable cryptographic toolkit"
HOMEPAGE="http://libtom.org/?page=features&whatfile=crypt"
SRC_URI="http://libtom.org/files/crypt-${PV}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc libtommath tomsfastmath"

RDEPEND="libtommath? ( dev-libs/libtommath )
	tomsfastmath? ( >=dev-libs/tomsfastmath-0.12 )
	!libtommath? ( !tomsfastmath? ( dev-libs/libtommath ) )"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base app-text/ghostscript-gpl )"

src_prepare() {
cp -av makefile.shared{,.orig}
	use doc || sed -i '/^install:/s:docs::' makefile
	epatch "${FILESDIR}"/libtomcrypt-1.17-r2-libtool-tag-and-make-fix.patch
	sed -i \
		-e 's|	gcc|	$(CC)|g' \
		-e '/^CC=/{
			s|^CC=|COMPILE=|g;
			s|gcc|--mode=compile $(CC) --tag CC $(CC)|g
		}' \
		-e 's|--mode=link gcc|--mode=link $(CC) $(LDFLAGS) --tag CC $(CC)|g' \
		{,testprof/}makefile.shared || die "sed makefile.shared"
}

src_compile() {
	local extraflags=""
	use libtommath && append-flags -DLTM_DESC && extraflags="-ltommath"
	use tomsfastmath && append-flags -DTFM_DESC && extraflags="${extraflags} -ltfm"
	EXTRALIBS="${extraflags}" \
		CC=$(tc-getCC) \
		IGNORE_SPEED=1 \
		emake -f makefile.shared \
		|| die "emake failed"
}

src_install() {
	emake -f makefile.shared DESTDIR="${D}" install ||\
		die "emake install failed"
	dodoc TODO changes || die "dodoc failed"
	if use doc ; then
		dodoc doc/* || die "dodoc failed"
		docinto notes ; dodoc notes/* || die "dodoc failed"
		docinto demos ; dodoc demos/* || die "dodoc failed"
	fi
}
