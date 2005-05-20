# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-calculators/calculator/calculator-1.0.53.ebuild,v 1.1 2005/05/20 03:27:54 rphillips Exp $

inherit fox

DESCRIPTION="Scientific calculator based on the FOX Toolkit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~ia64 ~ppc ~ppc64 ~sparc"
IUSE=""

RDEPEND=">=x11-libs/fox-1.0.53 <x11-libs/fox-1.1"
