# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-dist.eclass,v 1.31 2002/12/02 19:58:09 danarmak Exp $
# This is the kde-dist eclass for >=2.2.1 kde base packages. Don't use for kdelibs though :-)
# Don't use it for e.g. kdevelop, koffice because of their separate versionnig schemes.

inherit kde-base kde.org
ECLASS=kde-dist
INHERITED="$INHERITED $ECLASS"

need-kde $PV

# 3.1 prereleases
[ "$PV" == "3.1_alpha1" ] && S=${WORKDIR}/${PN}-3.0.6
[ "$PV" == "3.1_beta1" ] && S=${WORKDIR}/${PN}-3.0.7
[ "$PV" == "3.1_beta2" ] && S=${WORKDIR}/${PN}-3.0.8
[ "$PV" == "3.1_rc1" ] && S=${WORKDIR}/${PN}-3.0.9
[ "$PV" == "3.1_rc2" ] && S=${WORKDIR}/${PN}-3.0.98
[ "$PV" == "3.1_rc3" ] && S=${WORKDIR}/${PN}-3.0.99

DESCRIPTION="KDE ${PV} - "
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"

SLOT="$KDEMAJORVER.$KDEMINORVER"


