# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bzr/bzr-2.0.1.ebuild,v 1.6 2010/01/10 00:46:54 jer Exp $

EAPI=1

NEED_PYTHON=2.4

inherit distutils bash-completion elisp-common eutils versionator

MY_PV=${PV/_rc/rc}
MY_P=${PN}-${MY_PV}
SERIES=$(get_version_component_range 1-2)

DESCRIPTION="Bazaar is a next generation distributed version control system."
HOMEPAGE="http://bazaar-vcs.org/"
#SRC_URI="http://bazaar-vcs.org/releases/src/${MY_P}.tar.gz"
SRC_URI="http://launchpad.net/bzr/${SERIES}/${MY_PV}/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="curl doc emacs +sftp test"

RDEPEND="|| ( >=dev-lang/python-2.5 dev-python/celementtree )
	curl? ( dev-python/pycurl )
	sftp? ( dev-python/paramiko )"

DEPEND="emacs? ( virtual/emacs )
	test? (
		$RDEPEND
		dev-python/medusa
	)"

S="${WORKDIR}/${MY_P}"
PYTHON_MODNAME="bzrlib"
SITEFILE=71bzr-gentoo.el
DOCS="doc/*.txt"

src_unpack() {
	distutils_src_unpack

	# Don't regenerate .c files from .pyx when pyrex is found.
	epatch "${FILESDIR}/${PN}-1.8-no-pyrex.patch"
	# Don't run lock permission tests when running as root
	epatch "${FILESDIR}/${PN}-0.90-tests-fix_root.patch"
	# Fix permission errors when run under directories with setgid set.
	epatch "${FILESDIR}/${PN}-0.90-tests-sgid.patch"
}

src_compile() {
	distutils_src_compile

	if use emacs; then
		elisp-compile contrib/emacs/bzr-mode.el || die "Emacs modules failed!"
	fi
}

src_install() {
	distutils_src_install --install-data /usr/share

	if use doc; then
		docinto developers
		dodoc doc/developers/* || die "dodoc failed"
		for doc in mini-tutorial tutorials user-{guide,reference}; do
			docinto $doc
			dodoc doc/en/$doc/* || die "dodoc failed"
		done
	fi

	if use emacs; then
		elisp-install ${PN} contrib/emacs/*.el* || die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die "elisp-site-file-install failed"

		# don't add automatically to the load-path, so the sitefile
		# can do a conditional loading
		touch "${D}${SITELISP}/${PN}/.nosearch"
	fi

	insinto /usr/share/zsh/site-functions
	doins contrib/zsh/_bzr
	dobashcompletion contrib/bash/bzr
}

pkg_postinst() {
	distutils_pkg_postinst
	bash-completion_pkg_postinst

	if use emacs; then
		elisp-site-regen
		elog "If you are using a GNU Emacs version greater than 22.1, bzr support"
		elog "is already included.  This ebuild does not automatically activate bzr support"
		elog "in versions below, but prepares it in a way you can load it from your ~/.emacs"
		elog "file by adding"
		elog "       (load \"bzr-mode\")"
	fi
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}

src_test() {
	export LC_ALL=C
	# Define tests which are known to fail below.
	local skip_tests="("
	# Not reproducible in current dev version, so check and drop with version
	# bump
	skip_tests+="bzrlib.tests.test_osutils.TestWalkDirs|"
	# https://bugs.launchpad.net/bzr/+bug/392127
	skip_tests+="test_http.*"
	skip_tests+=")"
	# Some tests expect the usual pyc compiling behaviour.
	python_enable_pyc
	if [[ -n ${skip_tests} ]]; then
		einfo "Skipping tests known to fail: ${skip_tests}"
		"${python}" bzr --no-plugins selftest -x ${skip_tests} || die "bzr selftest failed"
	else
		"${python}" bzr --no-plugins selftest || die "bzr selftest failed"
	fi
	# Just to make sure we don't hit any errors on later stages.
	python_disable_pyc
}
