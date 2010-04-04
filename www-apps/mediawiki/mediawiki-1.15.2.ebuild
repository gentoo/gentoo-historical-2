# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/mediawiki/mediawiki-1.15.2.ebuild,v 1.2 2010/04/04 18:46:29 armin76 Exp $

EAPI="1"
inherit webapp depend.php versionator eutils

MY_BRANCH=$(get_version_component_range 1-2)

DESCRIPTION="The MediaWiki wiki web application (as used on wikipedia.org)"
HOMEPAGE="http://www.mediawiki.org"
SRC_URI="http://download.wikimedia.org/mediawiki/${MY_BRANCH}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~ppc sparc x86"
IUSE="imagemagick math mysql postgres +ocamlopt"

DEPEND="math? ( >=dev-lang/ocaml-3.0.6 )"
RDEPEND="${DEPEND}
	math? (
		app-text/dvipng
		virtual/tex-base
		app-text/ghostscript-gpl
		media-gfx/imagemagick
	)
	imagemagick? ( media-gfx/imagemagick )"

RESTRICT="test"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	local flags="pcre session spl xml"
	use mysql && flags="${flags} mysql"
	use postgres && flags="${flags} postgres"
	if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} || \
		! PHPCHECKNODIE="yes" require_php_with_any_use gd gd-external ; then
			die "Re-install ${PHP_PKG} with ${flags} and either gd or gd-external"
	fi

	# see Bug 204812
	if use ocamlopt && use math && ! built_with_use --missing true dev-lang/ocaml ocamlopt; then
		eerror "In order to build ${PN} with native code support from ocaml"
		eerror "You first need to have a native code ocaml compiler."
		eerror "You need to install dev-lang/ocaml with ocamlopt useflag on."
		die "Please install ocaml with ocamlopt useflag"
	fi
}

src_compile() {
	if use math; then
		einfo "Compiling math support"
		cd math || die
		if ! use ocamlopt; then
			sed -e "s/ocamlopt/ocamlc/" \
				-e "s/cmxa/cma/" \
				-e "s/cmx/cmo/g" -i Makefile || die
		fi
		emake || die
	else
		einfo "No math support enabled. Skipping."
	fi

	# TODO: 1. think about includes/zhtable/ support
	# 2. generate docs (?): echo '0' | php mwdocgen.php
}

src_install() {
	webapp_src_preinst

	# First we install math, docs and then copy everything left into htdocs dir
	# to avoid bugs like #236411.

	# If we've enabled math USE-flag, install math support.
	# We ensure the directories are prepared for writing.  The post-
	# install instructions guide the user to enable the feature.
	if use math; then
		einfo "Installing math support"
		exeinto "${MY_HTDOCSDIR}"/math
		doexe math/texvc || die "Failed to create math support executable."

		docinto math
		dodoc math/{README,TODO}
		docinto ""

		# Working directories.  Server writeable.
		dodir "${MY_HTDOCSDIR}"/images/math
		webapp_serverowned "${MY_HTDOCSDIR}"/images/math
		dodir "${MY_HTDOCSDIR}"/images/tmp
		webapp_serverowned "${MY_HTDOCSDIR}"/images/tmp
	fi

	local DOCS="FAQ HISTORY INSTALL README RELEASE-NOTES UPGRADE"
	dodoc ${DOCS} docs/*.txt
	docinto php-memcached
	dodoc docs/php-memcached/*

	# Clean everything not used at the site...
	rm -rf ${DOCS} COPYING tests math t docs
	find . -name Makefile -delete
	# and install
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	# If imagemagick is enabled then setup for image upload.
	# We ensure the directory is prepared for writing.
	if use imagemagick; then
		webapp_serverowned "${MY_HTDOCSDIR}"/images
	fi

	webapp_postinst_txt en "${FILESDIR}/postinstall-1.13-en.txt"
	webapp_postupgrade_txt en "${FILESDIR}/postupgrade-1.13-en.txt"
	webapp_src_install
}

pkg_preinst() {
	prev_instal="false"
	if has_version ${CATEGORY}/${PN}; then
		prev_instal="true"
	fi
}

pkg_postinst() {
	webapp_pkg_postinst
	if ${prev_instal}; then
		einfo
		elog "=== Consult the release notes ==="
		elog "Before doing anything, stop and consult the release notes"
		elog "/usr/share/doc/${PF}/RELEASE-NOTES.bz2"
		elog
		elog "These detail bug fixes, new features and functionality, and any"
		elog "particular points that may need to be noted during the upgrade procedure."
		einfo
		ewarn "Back up existing files and the database before upgrade."
		ewarn "http://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki"
		ewarn "provides an overview of the backup process."
		einfo
	fi
}
