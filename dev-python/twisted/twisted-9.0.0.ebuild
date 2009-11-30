# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted/twisted-9.0.0.ebuild,v 1.1 2009/11/30 01:29:35 arfrever Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils versionator

MY_P="TwistedCore-${PV}"

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="http://www.twistedmatrix.com/ http://pypi.python.org/pypi/Twisted"
SRC_URI="http://tmrc.mit.edu/mirror/${PN}/Core/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="crypt gtk serial"

DEPEND=">=net-zope/zope-interface-3.0.1
	serial? ( dev-python/pyserial )
	crypt? ( >=dev-python/pyopenssl-0.5.1 )
	gtk? ( >=dev-python/pygtk-1.99 )
	!dev-python/twisted-docs"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3*"

S="${WORKDIR}/${MY_P}"

DOCS="CREDITS NEWS README"

src_prepare(){
	# Give a load-sensitive test a better chance of succeeding.
	epatch "${FILESDIR}/${PN}-2.1.0-echo-less.patch"

	# Pass valid arguments to "head" in the zsh completion function.
	epatch "${FILESDIR}/${PN}-2.1.0-zsh-head.patch"
}

src_test() {
	testing() {
		"$(PYTHON)" setup.py build -b "build-${PYTHON_ABI}" install --root="${T}/tests" --no-compile || die "Installation of tests failed with Python ${PYTHON_ABI}"

		pushd "${T}/tests$(python_get_sitedir)" > /dev/null || die

		# Skip broken tests.
		rm -f twisted/python/test/test_release.py

		# Prevent it from pulling in plugins from already installed twisted packages.
		rm -f twisted/plugins/__init__.py

		# An empty file doesn't work because the tests check for
		# docstrings in all packages
		echo "'''plugins stub'''" > twisted/plugins/__init__.py || die

		PYTHONPATH=. "${T}/tests/usr/bin/trial" twisted || die "trial failed with Python ${PYTHON_ABI}"

		popd > /dev/null || die
		rm -fr "${T}/tests"
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	# get rid of this to prevent collision-protect from killing us. it
	# is regenerated in pkg_postinst.
	rm -f "${D}/usr/$(get_libdir)"/python*/site-packages/twisted/plugins/dropin.cache

	# weird pattern to avoid installing the index.xhtml page
	doman doc/man/*.?
	insinto /usr/share/doc/${PF}
	doins -r $(find doc -mindepth 1 -maxdepth 1 -not -name man)

	newconfd "${FILESDIR}/twistd.conf" twistd
	newinitd "${FILESDIR}/twistd.init" twistd

	# zsh completion
	insinto /usr/share/zsh/site-functions/
	doins twisted/python/_twisted_zsh_stub
}

update_plugin_cache() {
	local tpath="${ROOT}$(python_get_sitedir)/twisted"
	# we have to remove the cache or removed plugins won't be removed
	# from the cache (http://twistedmatrix.com/bugs/issue926)
	[[ -e "${tpath}/plugins/dropin.cache" ]] && rm -f "${tpath}/plugins/dropin.cache"
	if [[ -e "${tpath}/plugin.py" ]]; then
		# twisted is still installed, update.
	    # we have to use getPlugIns here for <=twisted-2.0.1 compatibility
		einfo "Regenerating plugin cache"
		"$(PYTHON)" -c "from twisted.plugin import IPlugin, getPlugIns;list(getPlugIns(IPlugin))"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	python_execute_function update_plugin_cache
}

pkg_postrm() {
	distutils_pkg_postrm
	python_execute_function update_plugin_cache
}
