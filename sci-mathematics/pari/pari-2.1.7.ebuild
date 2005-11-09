# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pari/pari-2.1.7.ebuild,v 1.1 2005/11/09 16:23:26 george Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="pari (or pari-gp) : a software package for computer-aided number theory"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/pari/unix/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="doc emacs"

DEPEND="doc? ( virtual/tetex )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/docs.patch
}

src_compile() {
	# Fix usage of toolchain
	tc-getAS; tc-getLD; tc-getCC; tc-getCXX

	# Special handling for sparc
	local myhost
	[ "${PROFILE_ARCH}" == "sparc64" ] && myhost="sparc64-linux" \
		|| myhost="$(echo ${CHOST} | cut -f "1 3" -d '-')"
	einfo "Building for ${myhost}"

	#need to force optimization here, as it breaks without
	if   is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi
	#we also need to force -fPIC throughout on amd64
	if [ "${ARCH}" = "amd64" ] && ! is-flag -fPIC; then append-flags -fPIC; fi

	./Configure \
		--host=${myhost} \
		--prefix=/usr \
		--miscdir=/usr/share/doc/${PF} \
		--datadir=/usr/share/${P} \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man/man1 || die "./configure failed"
	addwrite "/var/lib/texmf"
	addwrite "/usr/share/texmf"
	addwrite "/var/cache/fonts"

	if use hppa
	then
		mymake=DLLD\=/usr/bin/gcc\ DLLDFLAGS\=-shared\ -Wl,-soname=\$\(LIBPARI_SONAME\)\ -lm
	fi

	# Shared libraries should be PIC on ALL architectures.
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/31
	# Fixes BUG #49583
	einfo "Building shared library..."
	cd Olinux-* || die "Bad directory. File a BUG!"
	emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE -fPIC" lib-dyn || die "Building shared library failed!"

	einfo "Building executables..."
	emake ${mymake} CFLAGS="${CFLAGS} -DGCC_INLINE" gp ../gp || die "Building executables failed!"

	use doc || rm -rf doc/*.tex
	use doc && emake doc
}

src_test() {
	cd ${S}
	ebegin "Testing pari kernel"
	make CFLAGS="-Wl,-lpari" test-kernel > /dev/null
	eend $?
}

src_install() {
	make DESTDIR=${D} LIBDIR=${D}/usr/$(get_libdir) install || die
	if use emacs; then
		insinto /usr/share/emacs/site-lisp
		doins emacs/pari.el
	fi
	dodoc AUTHORS Announce.2.1 CHANGES README TODO
}
