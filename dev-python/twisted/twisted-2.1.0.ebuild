# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/twisted/twisted-2.1.0.ebuild,v 1.4 2006/01/06 05:38:46 vapier Exp $

inherit eutils distutils versionator

MY_P=Twisted-${PV}

DESCRIPTION="An asynchronous networking framework written in Python"
HOMEPAGE="http://www.twistedmatrix.com/"
SRC_URI="http://tmrc.mit.edu/mirror/twisted/Twisted/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sh ~sparc ~x86"
IUSE="gtk serial crypt"

DEPEND=">=dev-lang/python-2.2
	>=net-zope/zopeinterface-3.0.1
	serial? ( dev-python/pyserial )
	crypt? ( >=dev-python/pyopenssl-0.5.1 )
	gtk? ( >=dev-python/pygtk-1.99 )"

S="${WORKDIR}/${MY_P}"

DOCS="CREDITS INSTALL NEWS README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-trial-tests.patch"
	epatch "${FILESDIR}/${P}-trial-tests2.patch"
	epatch "${FILESDIR}/${P}-zsh-head.patch"
}

src_install() {
	distutils_src_install

	# get rid of this to prevent collision-protect from killing us. it
	# is regenerated in pkg_postinst.
	rm "${D}/usr/$(get_libdir)"/python*/site-packages/twisted/plugins/dropin.cache

	# weird pattern to avoid installing the index.xhtml page
	doman doc/man/*.?
	insinto /usr/share/doc/${PF}
	doins -r $(find doc -mindepth 1 -maxdepth 1 -not -name man)

	# workaround for a possible portage bug
	mkdir -p "${D}/etc/conf.d/"
	newconfd "${FILESDIR}/twistd.conf" twistd
	newinitd "${FILESDIR}/twistd.init" twistd

	# zsh completion
	insinto /usr/share/zsh/site-functions/
	doins twisted/python/_twisted_zsh_stub
}

update_plugin_cache() {
	python_version
	local tpath="${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/twisted"
	# we have to remove the cache or removed plugins won't be removed
	# from the cache (http://twistedmatrix.com/bugs/issue926)
	[[ -e "${tpath}/plugins/dropin.cache" ]] && rm -f "${tpath}/plugins/dropin.cache"
	if [[ -e "${tpath}/plugin.py" ]]; then
		# twisted is still installed, update.
	    # we have to use getPlugIns here for <=twisted-2.0.1 compatibility
		einfo "Regenerating plugin cache"
		python -c "from twisted.plugin import IPlugin, getPlugIns;list(getPlugIns(IPlugin))"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	update_plugin_cache
}

pkg_postrm() {
	distutils_pkg_postrm
	update_plugin_cache
}

src_test() {
	python_version

	if has_version ">=dev-lang/python-2.3"; then
		"${python}" setup.py install --root="${T}/tests" --no-compile || die
	else
		"${python}" setup.py install --root="${T}/tests" || die
	fi

	cd "${T}/tests/usr/$(get_libdir)/python${PYVER}/site-packages/" || die

	# prevent it from pulling in plugins from already installed
	# twisted packages
	rm twisted/plugins/__init__.py || die

	# an empty file doesn't work because the tests check for
	# docstrings in all packages
	echo "'''plugins stub'''" > twisted/plugins/__init__.py || die

	"${T}"/tests/usr/bin/trial twisted || die "trial failed"
	cd "${S}"
	rm -rf "${T}/tests"
}
