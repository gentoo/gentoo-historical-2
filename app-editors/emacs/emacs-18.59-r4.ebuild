# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/emacs/emacs-18.59-r4.ebuild,v 1.3 2007/05/28 14:42:54 opfer Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="The extensible self-documenting text editor"
HOMEPAGE="http://www.gnu.org/software/emacs/"
SRC_URI="mirror://gnu/old-gnu/emacs/${P}.tar.gz
	mirror://gentoo/emacs-18-patches.tar.bz2
	ftp://ftp.splode.com/pub/users/friedman/emacs/${P}-linux22x-elf-glibc21.diff.gz"

LICENSE="GPL-1"
SLOT="18"
KEYWORDS="x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	>=app-admin/eselect-emacs-0.3
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}"
PROVIDE="virtual/editor"

MY_BASEDIR="/usr/share/emacs/${PV}"
MY_LOCKDIR="/var/lib/emacs/lock"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${P}-linux22x-elf-glibc21.diff"
	epatch "${WORKDIR}/${P}-unexelf.patch"
	epatch "${WORKDIR}/${P}-gentoo.patch"
	epatch "${WORKDIR}/${P}-gcc4.patch"
}

src_compile() {
	SANDBOX_ON=0

	# autoconf? What's autoconf? We are living in 1992. ;-)
	local arch
	case ${ARCH} in
		x86)   arch=intel386 ;;
		*)	   die "Architecture ${ARCH} not supported" ;;
	esac
	local cmd="s/\"s-.*\.h\"/\"s-linux.h\"/;s/\"m-.*\.h\"/\"m-${arch}.h\"/"
	use X && cmd="${cmd};s/.*\(#define HAVE_X_WINDOWS\).*/\1/"
	sed -e "${cmd}" src/config.h-dist >src/config.h

	cat <<-END >src/paths.h
		#define PATH_LOADSEARCH "${MY_BASEDIR}/lisp"
		#define PATH_EXEC "${MY_BASEDIR}/etc"
		#define PATH_LOCK "${MY_LOCKDIR}/"
		#define PATH_SUPERLOCK "${MY_LOCKDIR}/!!!SuperLock!!!"
	END

	# -O3 and -finline-functions cause segmentation faults at run time.
	filter-flags -finline-functions
	replace-flags -O[3-9] -O2
	strip-flags

	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Demacs" || die
}

src_install() {
	dodir ${MY_BASEDIR}
	dodir /usr/share/man/man1
	make install LIBDIR="${D}${MY_BASEDIR}" BINDIR="${D}/usr/bin" \
		MANDIR="${D}/usr/share/man/man1" || die
	chmod -R go-w "${D}${MY_BASEDIR}"
	rmdir "${D}${MY_BASEDIR}/lock"

	dodir ${MY_LOCKDIR%/*}
	diropts -m0777
	dodir ${MY_LOCKDIR}
	keepdir ${MY_LOCKDIR}

	for i in emacsclient etags ctags; do
		mv "${D}"/usr/bin/${i}{,-emacs-${SLOT}} || die "mv ${i} failed"
	done
	mv "${D}"/usr/bin/emacs{,-${SLOT}} || die "mv emacs failed"
	mv "${D}"/usr/share/man/man1/emacs{,-emacs-${SLOT}}.1 || die
	dosym ../emacs/${PV}/info /usr/share/info/emacs-${SLOT}

	dodoc README PROBLEMS
}

pkg_postinst() {
	eselect emacs update --if-unset
}

pkg_postrm() {
	eselect emacs update --if-unset
}
