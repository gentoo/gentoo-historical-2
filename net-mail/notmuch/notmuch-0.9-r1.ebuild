# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/notmuch/notmuch-0.9-r1.ebuild,v 1.2 2011/11/03 17:35:07 aidecoe Exp $

EAPI=4

PYTHON_DEPEND="python? 2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit elisp-common distutils
inherit autotools-utils

DESCRIPTION="The mail indexer"
HOMEPAGE="http://notmuchmail.org/"
SRC_URI="${HOMEPAGE}/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="test? ( emacs )"
IUSE="bash-completion debug emacs python test vim zsh-completion"

CDEPEND="
	>=dev-libs/glib-2.14
	dev-libs/gmime:2.4
	dev-libs/xapian
	sys-libs/talloc
	debug? ( dev-util/valgrind )
	emacs? ( >=virtual/emacs-23 )
	x86? ( >=dev-libs/xapian-1.2.7-r2 )
	vim? ( || ( >=app-editors/vim-7.0 >=app-editors/gvim-7.0 ) )
	"
DEPEND="${CDEPEND}
	test? ( sys-devel/gdb )
	"
RDEPEND="${CDEPEND}
	zsh-completion? ( app-shells/zsh )
	"

DOCS=( AUTHORS NEWS README TODO )
PATCHES=(
	"${FILESDIR}/${PV}-fix-lib-makefile-local.patch"
	"${FILESDIR}/${PV}-emacsetcdir.patch"
	)
SITEFILE="50${PN}-gentoo.el"

py_bindings() {
	if use python; then
		pushd bindings/python || die
		$@
		popd || die
	fi
}

pkg_setup() {
	if use emacs; then
		elisp-need-emacs 23 || die "Emacs version too low"
	fi
	use python && python_pkg_setup
}

src_prepare() {
	autotools-utils_src_prepare
	py_bindings distutils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--bashcompletiondir="${ROOT}/usr/share/bash-completion"
		--emacslispdir="${ROOT}/${SITELISP}/${PN}"
		--emacsetcdir="${ROOT}/${SITEETC}/${PN}"
		--zshcompletiondir="${ROOT}/usr/share/zsh/site-functions"
		$(use_with bash-completion)
		$(use_with emacs)
		$(use_with zsh-completion)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	py_bindings distutils_src_compile
}

src_install() {
	autotools-utils_src_install

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	fi

	if use vim; then
		insinto /usr/share/vim/vimfiles
		doins -r vim/plugin vim/syntax
	fi

	DOCS="" py_bindings distutils_src_install
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postrm
}
