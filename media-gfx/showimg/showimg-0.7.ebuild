# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: William McArthur <sandymac@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/showimg/showimg-0.7.ebuild,v 1.4 2002/05/21 18:14:10 danarmak Exp $

inherit kde-base || die

need-kde 2.2

S=${WORKDIR}/${P}

DESCRIPTION="ShowImg is a feature-rich image viewer for KDE"
SRC_URI="http://www.jalix.org/projects/showimg/download/${PVR}/${P}.tar.bz2"
HOMEPAGE="http://www.jalix.org/projects/showimg/"


