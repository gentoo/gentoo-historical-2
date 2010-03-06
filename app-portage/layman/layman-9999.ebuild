# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/layman/layman-9999.ebuild,v 1.8 2010/03/06 12:41:09 djc Exp $

EAPI="2"
NEED_PYTHON=2.5
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils git

DESCRIPTION="A python script for retrieving gentoo overlays."
HOMEPAGE="http://layman.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="git://layman.git.sourceforge.net/gitroot/layman/layman"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="bazaar cvs darcs git mercurial subversion test"

COMMON_DEPS="dev-lang/python[xml]"
DEPEND="${COMMON_DEPS}
	test? ( dev-util/subversion )
	app-text/xmlto"
RDEPEND="${COMMON_DEPS}
	bazaar? ( dev-vcs/bzr )
	cvs? ( dev-util/cvs )
	darcs? ( dev-util/darcs )
	git? ( dev-util/git )
	mercurial? ( dev-vcs/mercurial )
	subversion? (
		|| (
			>=dev-util/subversion-1.5.4[webdav-neon]
			>=dev-util/subversion-1.5.4[webdav-serf]
		)
	)"
RESTRICT_PYTHON_ABIS="2.4 3.*"

pkg_setup() {
	if ! has_version dev-util/subversion; then
		ewarn "You do not have dev-util/subversion installed!"
		ewarn "While layman does not exactly depend on this"
		ewarn "version control system you should note that"
		ewarn "most available overlays are offered via"
		ewarn "dev-util/subversion. If you do not install it"
		ewarn "you will be unable to use these overlays."
		ewarn
	fi
}

src_test() {
	testing() {
		for suite in layman/tests/{dtest,external}.py ; do
			PYTHONPATH="." "$(PYTHON)" ${suite} \
					|| die "test suite '${suite}' failed"
		done
	}
	python_execute_function testing
}

src_compile() {
	distutils_src_compile
	emake -C doc || die "emake -C doc failed"
}

src_install() {
	distutils_src_install

	dodir /etc/layman

	cp etc/layman.cfg "${D}"/etc/layman/

	doman doc/layman.8
	dohtml doc/layman.8.html

	keepdir /var/lib/layman
}

pkg_postinst() {
	distutils_pkg_postinst

	einfo "You are now ready to add overlays into your system."
	einfo
	einfo "  layman -L"
	einfo
	einfo "will display a list of available overlays."
	einfo
	elog  "Select an overlay and add it using"
	elog
	elog  "  layman -a overlay-name"
	elog
	elog  "If this is the very first overlay you add with layman,"
	elog  "you need to append the following statement to your"
	elog  "/etc/make.conf file:"
	elog
	elog  "  source /var/lib/layman/make.conf"
	elog
	elog  "If you modify the 'storage' parameter in the layman"
	elog  "configuration file (/etc/layman/layman.cfg) you will"
	elog  "need to adapt the path given above to the new storage"
	elog  "directory."
	elog
	ewarn "Please add the 'source' statement to make.conf only AFTER "
	ewarn "you added your first overlay. Otherwise portage will fail."
	epause 5
}
