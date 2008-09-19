# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mercurial/mercurial-1.0.2.ebuild,v 1.1 2008/09/19 02:01:48 yngwin Exp $

inherit bash-completion elisp-common flag-o-matic eutils distutils

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="http://www.selenic.com/mercurial/"
SRC_URI="http://www.selenic.com/mercurial/release/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="bugzilla emacs gpg test zsh-completion"

CDEPEND=">=dev-lang/python-2.3"
RDEPEND="${CDEPEND}
	bugzilla? ( dev-python/mysql-python )
	gpg? ( app-crypt/gnupg )
	zsh-completion? ( app-shells/zsh )"
DEPEND="${CDEPEND}
	emacs? ( virtual/emacs )
	test? ( app-arch/unzip
		dev-python/pygments )"

PYTHON_MODNAME="${PN} hgext"
SITEFILE="70${PN}-gentoo.el"

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

src_test() {
	cd "${S}/tests/"
	rm -f *svn*		# Subversion tests fail with 1.5
	rm -f test-convert-baz*		# GNU Arch baz
	rm -f test-convert-cvs*		# CVS
	rm -f test-convert-darcs*	# Darcs
	rm -f test-convert-git*		# git
	rm -f test-convert-mtn*		# monotone
	rm -f test-convert-tla*		# GNU Arch tla
	einfo "Running Mercurial tests ..."
	python run-tests.py || die "test failed"
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
	bash-completion_pkg_postinst

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-util/cvs"
	elog "  dev-util/darcs"
	elog "  dev-util/git"
	elog "  dev-util/monotone"
	elog "  dev-util/subversion"
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
