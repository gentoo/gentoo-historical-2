# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gnome-pty-helper/gnome-pty-helper-0.28.1.ebuild,v 1.3 2011/06/28 22:08:37 ranger Exp $

EAPI="3"
GNOME_ORG_MODULE="vte"
GNOME_TARBALL_SUFFIX="xz"

inherit gnome.org base

DESCRIPTION="GNOME Setuid helper for opening ptys"
HOMEPAGE="http://git.gnome.org/browse/vte/"
# gnome-pty-helper is inside vte

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

# gnome-pty-helper was spit out with 0.27.90
RDEPEND="!<x11-libs/vte-0.27.90"
DEPEND=""

S="${WORKDIR}/vte-${PV}/gnome-pty-helper"
