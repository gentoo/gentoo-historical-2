# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/etckeeper/etckeeper-0.63.ebuild,v 1.9 2012/07/24 21:18:08 hwoarang Exp $

EAPI=4

PYTHON_DEPEND="bazaar? 2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45] 3.* 2.7-pypy-*"

inherit eutils bash-completion-r1 python

DESCRIPTION="A collection of tools to let /etc be stored in a repository"
HOMEPAGE="http://kitenet.net/~joey/code/etckeeper/"
SRC_URI="http://git.kitenet.net/?p=${PN}.git;a=snapshot;h=refs/tags/${PV};sf=tgz -> ${P}.tar.gz"

LICENSE="GPL-2"
IUSE="bazaar"
KEYWORDS="amd64 x86"
SLOT="0"

VCS_DEPEND="
	dev-vcs/git
	dev-vcs/mercurial
	dev-vcs/darcs
	dev-vcs/bzr"
DEPEND="bazaar? ( dev-vcs/bzr )"
RDEPEND="${DEPEND}
	app-portage/portage-utils
	|| ( ${VCS_DEPEND} )"

src_prepare(){
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	use bazaar && emake
}

src_install(){
	default

	bzr_install() {
		$(PYTHON) ./etckeeper-bzr/__init__.py install --root="${D}" ||
			die "bzr support installation failed!"
	}
	use bazaar && python_execute_function bzr_install

	newbashcomp bash_completion ${PN}
	docinto examples
	dodoc "${FILESDIR}"/bashrc
}

pkg_postinst(){
	elog "${PN} supports the following VCS: ${VCS_DEPEND}"
	elog "This ebuild just ensures at least one is installed!"
	elog "For dev-vcs/bzr you additionally need to enable 'bazaar' useflag."
	elog
	elog "You may want to adjust your /etc/portage/bashrc"
	elog "see the example file in /usr/share/doc/${P}/examples"
	elog
	elog "To initialise your etc-dir as a repository run:"
	elog "${PN} init -d /etc"
}
