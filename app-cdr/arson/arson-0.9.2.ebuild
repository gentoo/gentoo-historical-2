# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-cdr/arson/arson-0.9.2.ebuild,v 1.1 2002/01/09 20:02:12 danarmak Exp $
. /usr/portage/eclass/inherit.eclass || die
inherit kde-base

need-kde 2.2

S=${WORKDIR}/arson

DESCRIPTION="A KDE frontend to CD burning and CD ripping tools."
SRC_URI="http://telia.dl.sourceforge.net/arson/${P}.tar.bz2"
HOMEPAGE="http://arson.sourceforge.net/"
