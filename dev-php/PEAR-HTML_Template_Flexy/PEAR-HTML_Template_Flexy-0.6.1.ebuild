# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-HTML_Template_Flexy/PEAR-HTML_Template_Flexy-0.6.1.ebuild,v 1.1 2003/12/23 22:16:24 coredumb Exp $

inherit php-pear

IUSE="javascript"
DESCRIPTION="An extremely powerful Tokenizer driven Template engine"
LICENSE="PHP"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
DEPEND="javascript? ( >=dev-php/PEAR-HTML_Javascript-1.1.0 )"
