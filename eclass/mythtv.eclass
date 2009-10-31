# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mythtv.eclass,v 1.19 2009/10/31 22:10:58 cardoe Exp $
#
# @ECLASS: mythtv.eclass
# @AUTHOR: Doug Goldstein <cardoe@gentoo.org>
# @MAINTAINER: Doug Goldstein <cardoe@gentoo.org>
# @BLURB: Downloads the MythTV source packages and any patches from the fixes branch
#

inherit versionator

# Release version
MY_PV="${PV%_*}"

# what product do we want
case "${PN}" in
	       mythtv) MY_PN="mythtv";;
	mythtv-themes) MY_PN="myththemes";;
	mythtv-themes-extra) MY_PN="themes";;
	            *) MY_PN="mythplugins";;
esac

# _pre is from SVN trunk while _p and _beta are from SVN ${MY_PV}-fixes
# TODO: probably ought to do something smart if the regex doesn't match anything
[[ "${PV}" =~ (_alpha|_beta|_pre|_rc|_p)([0-9]+) ]] || {
	eerror "Invalid version requested (_alpha|_beta|_pre|_rc|_p) only"
	exit 1
}

REV_PREFIX="${BASH_REMATCH[1]}" # _alpha, _beta, _pre, _rc, or _p
MYTHTV_REV="${BASH_REMATCH[2]}" # revision number

case $REV_PREFIX in
	_pre|_alpha) MYTHTV_REPO="trunk";;
	_p|_beta|_rc) VER_COMP=( $(get_version_components ${MY_PV}) )
	          FIXES_VER="${VER_COMP[0]}-${VER_COMP[1]}"
	          MYTHTV_REPO="branches/release-${FIXES_VER}-fixes";;
esac

HOMEPAGE="http://www.mythtv.org"
LICENSE="GPL-2"
SRC_URI="http://svn.mythtv.org/trac/changeset/${MYTHTV_REV}/${MYTHTV_REPO}/${MY_PN}?old_path=%2F&format=zip -> ${MY_PN}-${PV}.zip"
S="${WORKDIR}/${MYTHTV_REPO}/${MY_PN}"
