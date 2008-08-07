# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-dimp/horde-dimp-1.0.1_rc1.ebuild,v 1.2 2008/08/07 20:42:10 mr_bones_ Exp $

HORDE_PHP_FEATURES="imap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Horde DIMP is a alternate presentation view of IMP using AJAX-ish
technologies"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3.2 >=www-apps/horde-groupware-1 )
	|| ( >=www-apps/horde-imp-4.2 >=www-apps/horde-groupware-1 )
	!www-apps/horde-webmail"
