# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cmake/cmake-2.6.1.ebuild,v 1.1 2008/08/27 21:19:10 tgurr Exp $

EAPI="1"

inherit elisp-common toolchain-funcs eutils versionator flag-o-matic

MY_PV="${PV/rc/RC-}"
MY_P="${PN}-$(replace_version_separator 3 - ${MY_PV})"

DESCRIPTION="Cross platform Make"
HOMEPAGE="http://www.cmake.org/"
SRC_URI="http://www.cmake.org/files/v$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="CMake"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="emacs qt4 vim-syntax"

DEPEND=">=net-misc/curl-7.16.4
	>=dev-libs/expat-2.0.1
	>=dev-libs/libxml2-2.6.28
	>=dev-libs/xmlrpc-c-1.06.09
	emacs? ( virtual/emacs )
	qt4? ( || ( ( x11-libs/qt-core:4
			x11-libs/qt-gui:4 )
		>=x11-libs/qt-4.3:4 ) )
	vim-syntax? ( || (
		app-editors/vim
		app-editors/gvim ) )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"
VIMFILE="${PN}.vim"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if ! built_with_use -o dev-libs/xmlrpc-c curl libwww; then
		echo
		eerror "${PN} requires dev-libs/xmlrpc-c to be built with either the 'libwww' or"
		eerror "the 'curl' USE flag or both enabled."
		eerror "Please re-emerge dev-libs/xmlrpc-c with USE=\"libwww\" or USE=\"curl\"."
		echo
		die "Please re-emerge dev-libs/xmlrpc-c with USE=\"libwww\" or USE=\"curl\"."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Upstream fix, compatibility with -Wl,--gc-sections, bug #235731
	epatch "${FILESDIR}/${PN}-2.6.1-gc-sections.patch"

	# Upstream fix, rpath handling security, bug #224901
	epatch "${FILESDIR}/${PN}-2.6.1-rpath.patch"

	# Link against the shared Python library rather than the static one
	epatch "${FILESDIR}/${PN}-FindPythonLibs.patch"
}

src_compile() {
	if [[ "$(gcc-major-version)" -eq "3" ]] ; then
		append-flags "-fno-stack-protector"
	fi

	tc-export CC CXX LD

	local qt_arg
	if use qt4; then
		qt_arg="--qt-gui"
	else
		qt_arg="--no-qt-gui"
	fi

	local par_arg
	echo $MAKEOPTS | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' > /dev/null
	if [ $? -eq 0 ]; then
		par_arg=$(echo $MAKEOPTS | egrep -o '(\-j|\-\-jobs)(=?|[[:space:]]*)[[:digit:]]+' | egrep -o '[[:digit:]]+')
		par_arg="--parallel=${par_arg}"
	else
		par_arg="--parallel=1"
	fi

	./bootstrap \
		--system-libs \
		--prefix=/usr \
		--docdir=/share/doc/${PF} \
		--datadir=/share/${PN} \
		--mandir=/share/man \
		"$qt_arg" \
		"$par_arg" || die "./bootstrap failed"

	emake || die "emake failed."
	if use emacs; then
		elisp-compile Docs/cmake-mode.el || die "elisp compile failed"
	fi
}

src_test() {
	emake test || \
		einfo "note test failure on qtwrapping was expected - nature of portage rather than a true failure"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	if use emacs; then
		elisp-install ${PN} Docs/cmake-mode.el Docs/cmake-mode.elc || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/Docs/cmake-syntax.vim

		insinto /usr/share/vim/vimfiles/indent
		doins "${S}"/Docs/cmake-indent.vim

		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${FILESDIR}/${VIMFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
