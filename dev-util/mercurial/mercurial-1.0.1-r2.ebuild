# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mercurial/mercurial-1.0.1-r2.ebuild,v 1.2 2008/07/03 00:38:34 gentoofan23 Exp $

inherit bash-completion distutils elisp-common flag-o-matic eutils

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="http://www.selenic.com/mercurial/"
SRC_URI="http://www.selenic.com/mercurial/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="bugzilla cvs darcs emacs git gpg subversion test zsh-completion"

CDEPEND=">=dev-lang/python-2.3"
RDEPEND="${CDEPEND}
	bugzilla? ( dev-python/mysql-python )
	cvs? ( dev-util/cvs )
	darcs? ( || ( dev-python/celementtree dev-python/elementtree ) )
	git? ( dev-util/git )
	gpg? ( app-crypt/gnupg )
	subversion? ( dev-util/subversion )
	zsh-completion? ( app-shells/zsh )"
DEPEND="${CDEPEND}
	emacs? ( virtual/emacs )
	test? ( app-arch/unzip )"

PYTHON_MODNAME="${PN} hgext"
SITEFILE="70${PN}-gentoo.el"

src_unpack() {
	distutils_src_unpack
	cd "${S}"
	epatch "${FILESDIR}/${P}-87c704ac92d4-git-patch.patch"
}

src_compile() {
	filter-flags -ftracer -ftree-vectorize

	distutils_src_compile

	if use emacs; then
		cd "${S}"/contrib
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi

	rm -rf contrib/{win32,macosx}
}

src_install() {
	distutils_src_install

	dobashcompletion contrib/bash_completion ${PN}

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh_completion _hg
	fi

	rm -f doc/*.?.txt
	dodoc CONTRIBUTORS PKG-INFO README doc/*.txt
	cp hgweb*.cgi "${D}"/usr/share/doc/${PF}/

	dobin contrib/hgk
	dobin contrib/hg-relink
	dobin contrib/hg-ssh

	rm -f contrib/hgk contrib/hg-relink contrib/hg-ssh

	rm -f contrib/bash_completion
	cp -r contrib "${D}"/usr/share/doc/${PF}/
	doman doc/*.?

	cat > "${T}/80mercurial" <<-EOF
HG=/usr/bin/hg
EOF
	doenvd "${T}/80mercurial"

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
	bash-completion_pkg_postinst
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
