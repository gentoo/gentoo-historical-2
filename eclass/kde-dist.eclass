# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-dist.eclass,v 1.25 2002/10/27 11:09:12 danarmak Exp $
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

DESCRIPTION="KDE ${PV} - "
HOMEPAGE="http://www.kde.org/"

# doesn't work well for unstable versions
if [ "$PV" != "3.1_alpha1" -a "$PV" != "3.1_beta1" -a "$PV" != "3.1_beta2" -a "$PV" != "5" ]; then
    set-enable-final
fi

LICENSE="GPL-2"

SLOT="$KDEMAJORVER.$KDEMINORVER"


