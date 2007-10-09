# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pari/pari-2.3.2.ebuild,v 1.9 2007/10/09 15:02:44 angelos Exp $

inherit elisp-common eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A software package for computer-aided number theory"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/pari/unix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ~mips ~ppc sparc x86"
IUSE="doc emacs X"

DEPEND="doc? ( virtual/tetex )
		sys-libs/readline
		X? ( x11-libs/libX11 )
		emacs? ( virtual/emacs )"
SITEFILE=50${PN}-gentoo.el

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable default building of docs during install
	sed -e "s:install-doc install-examples:install-examples:" \
		-i config/Makefile.SH || die "Failed to fix makefile"
}

src_compile() {
	# Special handling for sparc
	local myhost
	[ "${PROFILE_ARCH}" == "sparc64" ] && myhost="sparcv9-linux" \
		|| myhost="$(echo ${CHOST} | cut -f "1 3" -d '-')"
	einfo "Building for ${myhost}"

	#need to force optimization here, as it breaks without
	if   is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi

	./Configure \
		--host=${myhost} \
		--prefix=/usr \
		--datadir=/usr/share/${P} \
		--libdir=/usr/$(get_libdir) \
		--mandir=/usr/share/man/man1 || die "./configure failed"

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

	if use doc; then
		cd "${S}"
		emake docpdf || die "Failed to generate docs"
	fi

	if use emacs; then
		cd "${S}/emacs"
		elisp-comp *.el || die "elisp-comp failed"
	fi
}

src_test() {
	cd "${S}"
	ebegin "Testing pari kernel"
	make test-kernel
	eend $?
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install || \
		die "Install failed"

	if use emacs; then
		elisp-install ${PN} emacs/*.el emacs/*.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	dodoc AUTHORS Announce.2.1 CHANGES README TODO NEW
	if use doc; then
		emake DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install-doc \
			|| die "Failed to install docs"
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die "Failed to install pdf docs"
	fi

	#remove superfluous doc directory
	rm -fr "${D}/usr/share/${P}/doc" || \
		die "Failed to clean up doc directory"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
