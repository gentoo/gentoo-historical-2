# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/emacs-common-gentoo/emacs-common-gentoo-1.0.ebuild,v 1.6 2009/03/19 11:04:12 ulm Exp $

inherit elisp-common eutils fdo-mime gnome2-utils

DESCRIPTION="Common files needed by all GNU Emacs versions"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="X"

PDEPEND="virtual/emacs"

pkg_setup() {
	if [ -e "${ROOT}${SITELISP}/subdirs.el" ] \
		&& ! has_version ">=${CATEGORY}/${PN}-1"
	then
		ewarn "Removing orphan subdirs.el (installed by old Emacs ebuilds)"
		rm -f "${ROOT}${SITELISP}/subdirs.el"
	fi

	NEW_INSTALL=""
	has_version ${CATEGORY}/${PN} || NEW_INSTALL="true"
}

src_install() {
	elisp-install . subdirs.el || die

	if use X; then
		local i
		domenu emacs.desktop emacsclient.desktop || die
		newicon emacs_48.png emacs.png || die
		for i in 16 24 32 48; do
			insinto /usr/share/icons/hicolor/${i}x${i}/apps
			newins emacs_${i}.png emacs.png || die
		done
	fi
}

make-site-start() {
	ebegin "Creating default ${SITELISP}/site-start.el"
	cat <<-EOF >"${T}/site-start.el"
	;;; site-start.el			-*- no-byte-compile: t -*-

	;;; Commentary:
	;; This default site startup file for Emacs was created by package
	;; ${CATEGORY}/${PF}. You may modify this file, replace
	;; it by your own site initialisation, or even remove it completely.

	;;; Code:
	;; Load site initialisation for Gentoo installed packages.
	(require 'site-gentoo)

	;;; site-start.el ends here
	EOF
	mv "${T}/site-start.el" "${ROOT}${SITELISP}/site-start.el"
	eend $? "Installation of site-start.el failed"
}

pkg_config() {
	if [ ! -e "${ROOT}${SITELISP}/site-start.el" ]; then
		einfo "Press ENTER to create a default site-start.el file"
		einfo "for GNU Emacs, or Control-C to abort now ..."
		read
		make-site-start
	else
		einfo "site-start.el for GNU Emacs already exists."
	fi
}

pkg_postinst() {
	if use X; then
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi

	# make sure that site-gentoo.el exists since site-start.el requires it
	elisp-site-regen

	if [ ! -e "${ROOT}${SITELISP}/site-start.el" ]; then
		local line
		echo
		while read line; do elog "${line:- }"; done <<-EOF
		All site initialisation for Gentoo-installed packages is added to
		/usr/share/emacs/site-lisp/site-gentoo.el. In order for this site
		initialisation to be loaded for all users automatically, a default
		site-start.el is created in the same directory. You are responsible
		for all further maintenance of this file.

		Alternatively, individual users can add the following command:

		(require 'site-gentoo)

		to their ~/.emacs initialisation files, or, for greater flexibility,
		users may load single package-specific initialisation files from
		/usr/share/emacs/site-lisp/site-gentoo.d/.
		EOF
		echo

		if [ "${NEW_INSTALL}" ]; then
			# This is a new install. Create default site-start.el, so that
			# Gentoo packages will work.
			make-site-start
		else
			# This package was already installed, but site-start.el does
			# not exist. Give a hint how to (re-)create it.
			elog "If this is a new install, you may want to run:"
			elog "emerge --config =${CATEGORY}/${PF}"
		fi
	fi
}

pkg_postrm() {
	if use X; then
		fdo-mime_desktop_database_update
		gnome2_icon_cache_update
	fi
}
