# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/gnus/gnus-5.10.ebuild,v 1.10 2008/05/29 13:44:18 ulm Exp $

inherit versionator

DESCRIPTION="Virtual for the Gnus newsreader"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE=""

RDEPEND="|| (
		>=app-emacs/gnus-5.10.8
		>=app-emacs/ngnus-0.6
		>=virtual/emacs-22
	)"

DEPEND="${RDEPEND}
	virtual/emacs"

pkg_setup () {
	local gvn=$(emacs -batch -q \
		--eval "(and (require 'gnus nil t) (princ gnus-version-number))")

	if [ "${gvn}" ] && version_is_at_least ${PV} "${gvn}"; then
		einfo "Gnus version ${gvn} detected."
	elif has_version app-emacs/ngnus; then
		# ngnus doesn't follow the usual versioning scheme
		einfo "No Gnus version ${gvn} detected."
	else
		eerror "virtual/${P} requires at least Gnus version ${PV}."
		eerror "You should either install package app-emacs/{gnus,ngnus},"
		eerror "or use \"eselect emacs\" to select an Emacs version >= 22."
		die "Gnus version ${gvn} is too low."
	fi
}
